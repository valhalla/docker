#!/usr/bin/env bash

# set path
export  PATH=${PATH}:/usr/local/bin

# build configuration
export LOKI_PROXY_IN=$(jq -r ".loki.service.proxy" conf/valhalla.json)_in
export LOKI_PROXY_OUT=$(jq -r ".loki.service.proxy" conf/valhalla.json)_out

export ODIN_PROXY_IN=$(jq -r ".odin.service.proxy" conf/valhalla.json)_in
export ODIN_PROXY_OUT=$(jq -r ".odin.service.proxy" conf/valhalla.json)_out

export THOR_PROXY_IN=$(jq -r ".thor.service.proxy" conf/valhalla.json)_in
export THOR_PROXY_OUT=$(jq -r ".thor.service.proxy" conf/valhalla.json)_out

export TYR_PROXY_IN=$(jq -r ".tyr.service.proxy" conf/valhalla.json)_in
export TYR_PROXY_OUT=$(jq -r ".tyr.service.proxy" conf/valhalla.json)_out

export PRIME_LISTEN=$(jq -r ".httpd.service.listen" conf/valhalla.json)
export PRIME_PROXY=$(jq -r ".loki.service.proxy" conf/valhalla.json)_in
export PRIME_LOOPBACK=$(jq -r ".httpd.service.loopback" conf/valhalla.json)

/usr/bin/supervisord -c /conf/supervisord.conf
