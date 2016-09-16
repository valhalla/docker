#!/usr/bin/env bash

usage() {
  echo "Usage: ${0} [ppa|source] [version_tag]"
  exit 1
}

if [ -z ${2} ]; then
  usage
elif [ ${1} != 'ppa' ] || [ ${1} != 'source' ]; then
  usage
else
  tag=${1}
fi

dir=conf
if [ ! -d "${dir}" ]; then
  git clone \
    --depth=1 \
    --recurse-submodules \
    --single-branch \
    --branch=master https://github.com/valhalla/conf.git
fi

docker build -f Dockerfile-ppa \
  --tag mapzen/valhalla-ppa:${tag} \
  --force-rm \
  .
