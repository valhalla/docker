#!/usr/bin/env bash

if [ -z ${1} ]; then
  echo "Usage: ${0} [version_tag]"
  exit 1
else
  tag=${1}
fi

DIRECTORY=conf
if [ ! -d "$DIRECTORY" ]; then

  git clone \
    --depth=1 \
    --recurse-submodules \
    --single-branch \
    --branch=master https://github.com/valhalla/conf.git
fi

docker build -f Dockerfile-source \
  --tag mapzen/valhalla-source:${tag} \
  --force-rm \
  .
