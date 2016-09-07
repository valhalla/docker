#!/bin/bash

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

# generate test data?
if [ ${GENERATE_TEST_DATA} = 'true' ]; then
  echo "$(date): generating test data."

  for i in ${TEST_DATA_EXTRACTS}; do
    wget -q ${TEST_DATA_URL}/${i}
  done

  mkdir -p /data/valhalla
  valhalla_build_admins -c conf/valhalla.json *.pbf
  valhalla_build_tiles -c conf/valhalla.json *.pbf
  echo "$(date): done generating test data."
fi

/usr/bin/supervisord -c /scripts/supervisord.conf
