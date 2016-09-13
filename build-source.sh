#!/usr/bin/env bash

dir=conf
if [ ! -d "${dir}" ]; then
  git clone \
    --depth=1 \
    --recurse-submodules \
    --single-branch \
    --branch=master https://github.com/valhalla/conf.git
fi

docker build -f Dockerfile-source \
  --tag mapzen/valhalla-source \
  --force-rm \
  .
