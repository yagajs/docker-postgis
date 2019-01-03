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
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
      gdal-dev proj4-dev \
    && apk add --no-cache \
      --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
      gdal \
    \
    && mkdir -p /tmp/geos /tmp/postgis \
    && curl -L http://geos.osgeo.org/snapshots/geos-`date -d yesterday +%Y%m%d`.tar.bz2 | tar xj --strip-components=1 -C /tmp/geos \
    && cd /tmp/geos \
    && ./configure && make && make install \
    \
    && curl -L http://postgis.net/stuff/postgis-$POSTGIS_VERSION.tar.gz | tar xz --strip-components=1 -C /tmp/postgis \
    && cd /tmp/postgis \
    && ./configure && make && make install && ldconfig /usr/local/lib/ /usr/local/lib/postgres && make comments-install \
    && cd / \
    && rm -Rf /tmp/postgis /tmp/geos \
    && apk del .fetch-deps .build-deps .build-deps-testing
