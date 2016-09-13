#!/bin/bash

docker run \
  --name valhalla \
  -d \
  -h valhalla \
  -p 127.0.0.1:8002:8002 \
  mapzen/valhalla-source:latest
