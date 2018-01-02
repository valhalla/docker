#!/usr/bin/env bash

# set path
export  PATH=${PATH}:/usr/local/bin

# build configuration
export SKADI_PROXY_IN=$(jq -r ".skadi.service.proxy" conf/valhalla.json)_in
export SKADI_PROXY_OUT=$(jq -r ".skadi.service.proxy" conf/valhalla.json)_out

export PRIME_LISTEN=$(jq -r ".httpd.service.listen" conf/valhalla.json)
export PRIME_PROXY=$(jq -r ".skadi.service.proxy" conf/valhalla.json)_in
export PRIME_LOOPBACK=$(jq -r ".httpd.service.loopback" conf/valhalla.json)
export PRIME_INTERRUPT=$(jq -r ".httpd.service.interrupt" conf/valhalla.json)

exec /usr/bin/supervisord -n -c /conf/supervisord_elevation.conf
