#!/bin/bash

REGION=${REGION:-"us-east-1"}
DATA_DIR="/data/valhalla"

# some defaults, if needed.
export OSMLR_DIR=${OSMLR_DIR:-"${DATA_DIR}/osmlr"}
export NUMBER_OF_THREADS=${NUMBER_OF_THREADS:-"4"}

if [ -n "${AWS_TRAFFIC_PROFILE}" ]; then
  AWS_TRAFFIC_PROFILE=" --profile ${AWS_TRAFFIC_PROFILE} "
else 
  AWS_TRAFFIC_PROFILE=" "
fi

if [ -n "${AWS_MAPZEN_PROFILE}" ]; then
  AWS_MAPZEN_PROFILE=" --profile ${AWS_MAPZEN_PROFILE} "
else
  AWS_MAPZEN_PROFILE=" "
fi

clean_s3() {
  cutoff=$(date -d "-${2} days" +%s)
  aws${AWS_TRAFFIC_PROFILE}--region ${REGION} s3 ls ${1} | tail -n +2 | while read record; do
    added=$(date -d "$(echo ${record} | awk '{print $1" "$2}')" +%s)
    if [[ ${added} -lt ${cutoff} ]]; then
      aws${AWS_TRAFFIC_PROFILE}s3 rm ${1}$(echo ${record} | awk '{print $4}')
    fi
  done
}

get_latest_osmlr() {
  file=$(aws${AWS_TRAFFIC_PROFILE}s3 ls ${1}osmlr_ | sort | tail -1)
  file_name=$(echo ${file} | awk '{print $4}')
  latest_upload=${1}${file_name}

  #use the latest...if not already
  if [ ! -f ${DATA_DIR}/${file_name} ]; then
    # rm old tarball
    rm -f ${DATA_DIR}/osmlr_*.tgz
    aws${AWS_TRAFFIC_PROFILE}--region ${REGION} s3 cp $latest_upload ${DATA_DIR}/${file_name}
    # remove old data
    rm -rf ${OSMLR_DIR}
    mkdir ${OSMLR_DIR}
    tar pxf ${DATA_DIR}/${file_name} -C ${OSMLR_DIR}
  fi
}

get_latest_tiles() {
  file=$(aws${AWS_MAPZEN_PROFILE}s3 ls ${1}planet_ | sort | tail -1)
  file_name=$(echo ${file} | awk '{print $4}')
  latest_upload=${1}${file_name}

  rm -f ${DATA_DIR}/tiles.tar
  aws${AWS_MAPZEN_PROFILE}--region ${REGION} s3 cp $latest_upload ${DATA_DIR}/tiles.tar
  tar pxf ${DATA_DIR}/tiles.tar -C ${DATA_DIR}
}

catch_exception() {
  if [ $? != 0 ]; then
    echo "[FAILURE] Detected non zero exit status while associating segments!"
    exit 1
  fi
}

# clean up from previous runs
if [ -d "${DATA_DIR}" ]; then
  echo "[INFO] Removing contents of prior run in ${DATA_DIR}..."
  rm -rf "${DATA_DIR}/0/*"; catch_exception
  rm -rf "${DATA_DIR}/1/*"; catch_exception
  rm -rf "${DATA_DIR}/2/*"; catch_exception
fi

# create data dir
mkdir -p "${DATA_DIR}"; catch_exception

#osmlr data
get_latest_osmlr s3://osmlr-planet/

#tiles
get_latest_tiles s3://mapzen.valhalla/prod/

echo "[INFO] Associating segments... "
valhalla_associate_segments \
  -t ${OSMLR_DIR} \
  -j ${NUMBER_OF_THREADS} \
  --config conf/valhalla.json
catch_exception

echo "[SUCCESS] valhalla_associate_segments completed!"

# time_stamp
stamp=$(date +%Y_%m_%d-%H_%M_%S)

# upload to s3
if  [ -n "$SEGMENT_S3_PATH" ]; then
  echo "[INFO] Copying segments to S3... "
  tar pcf - -C ${DATA_DIR} . --exclude ./osmlr | pigz -9 > ${DATA_DIR}/segments_${stamp}.tgz
  catch_exception

  #save this qtr and last qtrs data.
  clean_s3 s3://mapzen.valhalla/dev/ 185

  #push up to s3 the new file
  aws${AWS_TRAFFIC_PROFILE}--region ${REGION} s3 cp ${DATA_DIR}/segments_${stamp}.tgz s3://${SEGMENT_S3_PATH}/ --acl public-read
  catch_exception
  rm -f ${DATA_DIR}/segments_${stamp}.tgz
  echo "[SUCCESS] segments successfully copied to S3!"
fi

# cya
echo "[SUCCESS] Run complete, exiting."
exit 0
