# Docker image for running integration tests

As CircleCI does not have Julia [Orbs](https://circleci.com/orbs/) yet, we rely
on a custom docker image to have access to Python, headless Chrome and Julia
in the same container.

Since <https://github.com/plotly/Dash.jl/pull/207>, we tag the build images
as [`etpinard/dashjl-tests`](https://hub.docker.com/r/etpinard/dashjl-tests). We
previously used the [`plotly/julia:ci`](https://hub.docker.com/r/plotly/julia/tags) image.

## When should we update the docker image?

The integration tests rely on the Python version of [dash](https://github.com/plotly/dash)
and its [testing framework](https://github.com/plotly/dash/tree/dev/dash/testing).

So, we should use the latest CircleCI python + browsers image latest Python version
that is included in the [dash CircleCI config](https://github.com/plotly/dash/blob/dev/.circleci/config.yml)
as our base image.

We should also update the Julia version from time to time. It might be nice to
run the integration tests on multiple Julia versions eventually.

## How to update the docker image?

Ask for push rights on docker hub first, then

```sh
cd Dash.jl/build
docker build -t etpinard:dashjl-tests:<x.y.z> .
docker push etpinard:dashjl-test:<x.y.z>
```

where `<x.y.z>` is the semver tag for the new image.

## CircleCI usage

This image is pulled from within Dash.jl's [CircleCI config.yml](../.circleci/config.yml):

```yaml
    docker:
      - image: etpinard/dashjl-tests:<x.y.z>
```

where `<x.y.z>` is the latest tag listed on <https://hub.docker.com/r/etpinard/dashjl-tests/tags>.

## Local usage

```sh
# grab a copy of the python (main) dash repo
cd Dash.jl
git clone --depth 1 https://github.com/plotly/dash.git -b dev dash-main

# start `dashjl-tests`
docker run -t -d --name dashjl-tests -v .:/home/circleci/project etpinard/dashjl-tests:<x.y.z>

# ssh into it as root (some python deps need that unfortunately)
docker exec -u 0 -it dashjl-tests bash

# [on 1st session] install pip deps
cd /home/circleci/project/dash-main
pip install --upgrade pip wheel
pip install -e .[ci,dev,testing] --progress-bar off

# [on 1st session] install chrome
cd /home/circleci
wget https://raw.githubusercontent.com/CircleCI-Public/browser-tools-orb/main/src/scripts/install-chrome.sh
chmod +x install-chrome.sh
ORB_PARAM_CHANNEL="stable" ORB_PARAM_CHROME_VERSION="latest" ./install-chrome.sh

# [on 1st session] install chromedriver
cd /home/circleci
wget https://raw.githubusercontent.com/CircleCI-Public/browser-tools-orb/main/src/scripts/install-chromedriver.sh
chmod +x ./install-chromedriver.sh
ORB_PARAM_DRIVER_INSTALL_DIR=/usr/local/bin/ ./install-chromedriver.sh

# [on 1st session] instantiate julia deps
cd /home/circleci/project/
julia --project -e 'import Pkg; Pkg.instantiate()'

# update julia deps then run integration tests
cd /home/circleci/project/
julia --project -e 'import Pkg; Pkg.update()'
pytest --headless --nopercyfinalize --percy-assets=test/assets/ test/integration/
```
