# Dash.jl integration tests

## How to tun integration tests locally inside test container

```
git clone --depth 1 https://github.com/plotly/dash.git -b dev dash-main

docker run -t -d --name dashjl-tests -v .:/home/circleci/project etpinard/dashjl-tests
docker exec -u 0 -it dashjl-tests bash

# [on 1st run] install pip deps
cd /home/circleci/project/dash-main
pip install --upgrade pip wheel
pip install -e .[ci,dev,testing] --progress-bar off

# [on 1st run] install chrome
cd /home/circleci
wget https://raw.githubusercontent.com/CircleCI-Public/browser-tools-orb/main/src/scripts/install-chrome.sh
chmod +x install-chrome.sh
ORB_PARAM_CHANNEL="stable" ORB_PARAM_CHROME_VERSION="latest" ./install-chrome.sh

# [on 1st run] install chromedriver
wget https://raw.githubusercontent.com/CircleCI-Public/browser-tools-orb/main/src/scripts/install-chromedriver.sh
chmod +x ./install-chromedriver.sh
ORB_PARAM_DRIVER_INSTALL_DIR=/usr/local/bin/ ./install-chromedriver.sh

# run integration tests
cd /home/circleci/project/
julia --project -e 'import Pkg; Pkg.instantiate()'
pytest --headless --nopercyfinalize --percy-assets=test/assets/ test/integration/
```
