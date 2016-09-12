## THIS IS A WORK IN PROGRESS!

### Run valhalla (local development)
`VALHALLA_DOCKER_DATAPATH=/some/path/to/data docker-compose -f docker-compose-{ppa|source}.yml up`

The routing engine will listen on and expose port 8002, and load any tile data found in `${VALHALLA_DOCKER_DATAPATH}`.

### To build/publish images
`./build-{ppa|source}.sh`
`docker push mapzen/valhalla-{ppa|source}`
