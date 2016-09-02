#!/bin/bash

if [ ${INSTALL_FROM} = 'source' ]; then
  PATH=${PATH}:./tools
else
  PATH=${PATH}:/usr/local/bin
fi

LOKI_PROXY_IN=$(jq -r ".loki.service.proxy" conf/valhalla.json)_in
LOKI_PROXY_OUT=$(jq -r ".loki.service.proxy" conf/valhalla.json)_out

ODIN_PROXY_IN=$(jq -r ".odin.service.proxy" conf/valhalla.json)_in
ODIN_PROXY_OUT=$(jq -r ".odin.service.proxy" conf/valhalla.json)_out

THOR_PROXY_IN=$(jq -r ".thor.service.proxy" conf/valhalla.json)_in
THOR_PROXY_OUT=$(jq -r ".thor.service.proxy" conf/valhalla.json)_out

TYR_PROXY_IN=$(jq -r ".tyr.service.proxy" conf/valhalla.json)_in
TYR_PROXY_OUT=$(jq -r ".tyr.service.proxy" conf/valhalla.json)_out

PRIME_LISTEN=$(jq -r ".httpd.service.listen" conf/valhalla.json)
PRIME_PROXY=$(jq -r ".loki.service.proxy" conf/valhalla.json)_in
PRIME_LOOPBACK=$(jq -r ".httpd.service.loopback" conf/valhalla.json)

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

echo "`date`: starting routing services."
echo "$(date): starting Loki worker..."
valhalla_loki_worker conf/valhalla.json &

echo "$(date): starting Odin worker..."
valhalla_odin_worker conf/valhalla.json &

echo "$(date): starting Thor worker..."
valhalla_thor_worker conf/valhalla.json &

echo "$(date): starting Tyr worker..."
valhalla_tyr_worker conf/valhalla.json &

echo "$(date): starting Loki proxy..."
prime_proxyd ${LOKI_PROXY_IN} ${LOKI_PROXY_OUT} &

echo "$(date): starting Odin proxy..."
prime_proxyd ${ODIN_PROXY_IN} ${ODIN_PROXY_OUT} &

echo "$(date): starting Thor proxy..."
prime_proxyd ${THOR_PROXY_IN} ${THOR_PROXY_OUT} &

echo "$(date): starting Tyr proxy..."
prime_proxyd ${TYR_PROXY_IN} ${TYR_PROXY_OUT} &

echo "$(date): starting Prime server..."
prime_proxyd ${PRIME_LISTEN} ${PRIME_PROXY} ${PRIME_LOOPBACK}
