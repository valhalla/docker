FROM ubuntu:14.04
MAINTAINER Grant Heffernan <grant@mapzen.com>

ENV TERM xterm
ENV INSTALL_FROM ppa
ENV PPA_VERSION ''
ENV GENERATE_TEST_DATA false

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install wget -y

ADD ./scripts /scripts
RUN /scripts/install.sh

ADD ./conf /conf

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8002
CMD ["/scripts/start_valhalla.sh"]
