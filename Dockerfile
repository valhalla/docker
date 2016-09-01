FROM ubuntu:14.04
MAINTAINER Grant Heffernan <grant@mapzen.com>

ENV TERM xterm
ENV INSTALL_FROM ppa
ENV PPA_VERSION ''
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install wget -y

COPY scripts/* /tmp/
RUN /tmp/install.sh

RUN wget https://s3.amazonaws.com/metro-extracts.mapzen.com/rome_italy.osm.pbf

ADD ./conf /conf
RUN mkdir -p /data/valhalla
RUN valhalla_build_admins -c conf/valhalla.json *.pbf
RUN valhalla_build_tiles -c conf/valhalla.json *.pbf

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8002
CMD ["tools/valhalla_route_service", "conf/valhalla.json"]
