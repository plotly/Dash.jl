# Dash.jl integration tests

## How to run the integration tests locally inside the `dashjl-tests` container

```sh
# grab a copy of the python (main) dash repo
git clone --depth 1 https://github.com/plotly/dash.git -b dev dash-main

# start `dashjl-tests`
docker run -t -d --name dashjl-tests -v .:/home/circleci/project etpinard/dashjl-tests:0.3.0
# ssh into it as root (some python deps need that)
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
