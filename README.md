## THIS IS A WORK IN PROGRESS!

### Run valhalla (local development)
`docker-compose -f docker-compose-{ppa|source}.yml up`

The routing engine will listen on and expose port 8002. The published container images are built around the supposition that you will be mounting and mapping a data volume on the host running the docker container. Export the env var `VALHALLA_DOCKER_DATAPATH=/some/path` before running `up`.

Alternatively, you can export `GENERATE_TEST_DATA=true`, which will download a small data extract with which to create some basic tile routing data.

### To build/publish images
`./build-{ppa|source}.sh`
`docker push mapzen/valhalla-{ppa|source}`
