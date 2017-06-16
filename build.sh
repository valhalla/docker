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

docker build -f Dockerfile-${build} \
  --tag valhalla/docker:${build}-${tag} \
  --no-cache \
  --force-rm \
  .
