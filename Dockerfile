FROM postgres:10-alpine

ARG POSTGIS_VERSION=2.4.0
ARG POSTGRES_MAJOR_VERSION=10

MAINTAINER Arne Schubert, atd.schubert@gmail.com

RUN set -x \
    && apk add --no-cache --virtual .fetch-deps \
      ca-certificates curl openssl tar \
    && apk add --no-cache --virtual .build-deps \
      g++ json-c-dev libtool libxml2-dev make perl coreutils \
    && apk add --no-cache --virtual .build-deps-testing \
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
      gdal-dev proj4-dev \
    \
    && curl -L http://geos.osgeo.org/snapshots/geos-`date -d yesterday +%Y%m%d`.tar.bz2 | tar xj -C /tmp \
    && cd /tmp/geos-`date -d yesterday +%Y%m%d` \
    && ./configure && make && make install \
    \
    && curl -L http://postgis.net/stuff/postgis-$POSTGIS_VERSION.tar.gz | tar xz -C /tmp \
    && cd /tmp/postgis-$POSTGIS_VERSION/ \
    && ./configure && make && make install && ldconfig && make comments-install \
    && apk del .fetch-deps .build-deps .build-deps-testing
