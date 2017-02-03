#!/usr/bin/env bash
set -e

# get all the ppas we might night
if [[ $(grep -cF trusty /etc/lsb-release) > 0 ]]; then
  sudo add-apt-repository -y ppa:kevinkreiser/libsodium
  sudo add-apt-repository -y ppa:kevinkreiser/libpgm
  sudo add-apt-repository -y ppa:kevinkreiser/zeromq3
  sudo add-apt-repository -y ppa:kevinkreiser/czmq
fi
sudo add-apt-repository -y ppa:kevinkreiser/prime-server
sudo apt-get update -y

# get all the dependencies might need
sudo apt-get install -y autoconf automake make libtool pkg-config g++ gcc jq lcov protobuf-compiler vim-common libboost-all-dev libboost-all-dev libcurl4-openssl-dev libprime-server0.6.3-dev libprotobuf-dev prime-server0.6.3-bin libgeos-dev libgeos++-dev liblua5.2-dev libspatialite-dev libsqlite3-dev lua5.2 python-all-dev
if [[ $(grep -cF xenial /etc/lsb-release) > 0 ]]; then
  sudo apt-get install -y libsqlite3-mod-spatialite
fi

# get the software installed
git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/valhalla.git libvalhalla
cd libvalhalla
./autogen.sh
./configure --enable-static
make -j$(nproc)
sudo make install

# clean up
ldconfig
rm -rf libvalhalla
