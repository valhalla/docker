#!/usr/bin/env bash
set -e

apt-get install -y git \
  libtool \
  automake \
  pkg-config \
  libcurl4-gnutls-dev \
  sudo \
  build-essential \
  libboost1.54-all-dev \
  software-properties-common

git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/mjolnir.git && \
  cd mjolnir && \
  ./scripts/dependencies.sh && \
  ./scripts/install.sh && \
  cd ..

git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/tools.git && \
  cd tools && \
  ./scripts/dependencies.sh && \
  ./scripts/install.sh && \
  cd ..

ldconfig
rm -rf mjolnir && rm -rf tools
