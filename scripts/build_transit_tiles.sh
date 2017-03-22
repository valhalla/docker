#!/bin/bash
set -e

# lockfile
LOCKFILE="${DATA}/.build_transit_lock"

echo "Checking for lockfile..."
if [ -f "${LOCKFILE}" ]; then
  echo "Lockfile present. Exiting."
  exit 1
else
  echo "Creating lockfile."
  touch ${LOCKFILE}
fi

#some defaults, if needed.
export TRANSIT_TILE_DIR=${TRANSIT_TILE_DIR:-"/data/valhalla/transit"}
export TRANSITLAND_URL=${TRANSITLAND_URL:-"http://transit.land"}
export TRANSITLAND_PER_PAGE=${TRANSITLAND_PER_PAGE:-5000}
export TRANSITLAND_LEVELS=${TRANSITLAND_LEVELS:-"4"}
mkdir -p ${TRANSIT_TILE_DIR}

# for now....build the timezones.
echo -e "Building timezones... \c"
valhalla_build_timezones conf/valhalla.json

# build transit tiles
echo -e "Building tiles... \c"
valhalla_build_transit \
  conf/valhalla.json \
  ${TRANSITLAND_URL} \
  ${TRANSITLAND_PER_PAGE} \
  ${TRANSIT_TILE_DIR} \
  ${TRANSITLAND_API_KEY} \
  ${TRANSITLAND_LEVELS} \
  ${TRANSITLAND_FEED} \
  ${TRANSIT_TEST_FILE}

echo "done!"

# upload to s3
if  [ -n "$TRANSIT_S3_PATH" ]; then
  echo -e "Copying tiles to S3... \c"
  aws s3 cp --recursive /data/valhalla "s3://${TRANSIT_S3_PATH}"
  echo "done!"
fi

# remove lockfile
echo "Removing lockfile..."
rm -f ${LOCKFILE}

# cya
echo "Run complete, exiting."
exit 0
