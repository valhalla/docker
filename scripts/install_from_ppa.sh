#!/usr/bin/env bash
set -e

# get all the ppas we might night
if [[ $(grep -cF trusty /etc/lsb-release) > 0 ]]; then
  add-apt-repository -y ppa:kevinkreiser/libsodium
  add-apt-repository -y ppa:kevinkreiser/libpgm
  add-apt-repository -y ppa:kevinkreiser/zeromq3
  add-apt-repository -y ppa:kevinkreiser/czmq
fi

apt-add-repository -y ppa:kevinkreiser/prime-server
apt-add-repository -y ppa:valhalla-routing/valhalla
apt-get update -y

apt-get install -y \
  libvalhalla0 \
  libvalhalla-dev \
  valhalla-bin
