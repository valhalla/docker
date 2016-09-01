# Dockerfile for Valhalla

This [Dockerfile](https://docs.docker.com/engine/reference/builder/) provides an easy way to build and deploy Mapzen's Valhalla, an open-source routing engine, without configuring [the full Chef install](https://github.com/valhalla/chef-valhalla).

---

***Not ready to mess with Docker or Chef? Mapzen provides hosted versions of these services under the names Turn-by-Turn, Matrix, and Elevation. Sign up for a free developer key at https://mapzen.com/developers/***

---

Back to this Dockerfile: It defaults to using an OpenStreetMap extract of Rome, IT, but you can change this if you like, in the Dockerfile. Browse Mapzen's [Metro Extracts service](https://mapzen.com/metro-extracts/) for other regions, and copy the URL for a OSM PBF-formatted extract.

To build the Docker image issue:

```sh
./build.sh
```

To run instead issue:

```sh
./run-valhalla.sh
```
