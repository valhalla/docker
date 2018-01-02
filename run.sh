#!/usr/bin/env bash

usage() {
  echo "Usage: ${0} [ppa|source] [tag]"
  exit 1
}

if [ -z ${2} ]; then
  usage
fi

if [ ${1} == "ppa" ] || [ ${1} == "source" ]; then
  run=${1}
  tag=${2}
else
  usage
fi

docker run \
  --name valhalla \
  -d \
  -h valhalla \
  -p 127.0.0.1:8002:8002 \
  valhalla/docker:${run}-${tag}
