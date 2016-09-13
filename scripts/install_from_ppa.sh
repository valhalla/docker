#!/bin/bash
set -e

apt-get install software-properties-common -y
apt-add-repository -y ppa:kevinkreiser/prime-server
apt-add-repository -y ppa:valhalla-routing/valhalla
apt-get update -y

d=$(echo ${PPA_VERSION} | sed -e 's/^.\\+$/-/g')
apt-get install -y \
  libvalhalla${PPA_VERSION}${d}0 \
  libvalhalla${PPA_VERSION}-dev \
  valhalla${PPA_VERSION}-bin
