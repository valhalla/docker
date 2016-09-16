#!/usr/bin/env bash

usage() {
  echo "Usage: ${0} [ppa|source] [version_tag]"
  exit 1
}

if [ -z ${2} ]; then
  usage
fi

if [ ${1} == "ppa" ] || [ ${1} == "source" ]; then
  build=${1}
  tag=${2}
else
  usage
fi

if [ ! -f "conf/valhalla.json" ]; then
  wget -q "https://raw.githubusercontent.com/valhalla/conf/master/valhalla.json" -O conf/valhalla.json
fi

docker build -f Dockerfile-${build} \
  --tag mapzen/valhalla-${build}:${tag} \
  --force-rm \
  .
