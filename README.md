# ynab4-docker

Run YNAB 4 on macOS using Docker

Note: Tested on macOS Mojave

## Setup

1. Install [Docker Desktop for Mac](https://download.docker.com/mac/stable/Docker.dmg)
1. Install [XQuartz 2.7.8](https://www.xquartz.org/releases/XQuartz-2.7.8.html)
1. Open XQuartz > Preferences > Security and check [Allow connections from network clients](https://user-images.githubusercontent.com/759811/59886353-3a06c880-9384-11e9-8453-345a0365dce3.png)
1. Log out and back in again
1. Download this repo: `wget https://github.com/bradymholt/ynab4-docker/archive/master.zip && unzip master.zip`
1. Run
```
cd ynab4-docker-master
./start.sh
```
