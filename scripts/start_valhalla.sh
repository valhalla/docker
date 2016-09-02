#!/bin/bash

PATH=${PATH}:/usr/local/bin

if [ ${GENERATE_TEST_DATA} = 'true' ]; then
  echo "`date`: generating test data." >/tmp/start_valhalla.log 2>&1
  apt-get install wget -y
  wget -q https://s3.amazonaws.com/metro-extracts.mapzen.com/rome_italy.osm.pbf
  mkdir -p /data/valhalla
  valhalla_build_admins -c conf/valhalla.json *.pbf
  valhalla_build_tiles -c conf/valhalla.json *.pbf
  echo "`date`: done generating test data." >/tmp/start_valhalla.log 2>&1
fi

echo "`date`: starting route service." >/tmp/start_valhalla.log 2>&1
if [ ${INSTALL_FROM} = 'ppa' ]; then
  valhalla_route_service conf/valhalla.json
elif [ ${INSTALL_FROM} = 'source' ]; then
  tools/valhalla_route_service conf/valhalla.json
fi
