#!/usr/bin/env bash
set -e

apt-add-repository -y ppa:kevinkreiser/prime-server
apt-add-repository -y ppa:valhalla-routing/valhalla
apt-get update -y

apt-get install -y \
  libvalhalla0 \
  libvalhalla-dev \
  valhalla-bin
