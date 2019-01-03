FROM postgres:10

ARG POSTGIS_VERSION=2.4.1
ARG POSTGRES_MAJOR_VERSION=10

MAINTAINER Arne Schubert, atd.schubert@gmail.com

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      curl ca-certificates build-essential libxml2-dev libgdal-dev libproj-dev libjson-c-dev xsltproc docbook-xsl docbook-mathml \
      postgresql-server-dev-$POSTGRES_MAJOR_VERSION  \
    \
    && mkdir -p /tmp/geos /tmp/postgis \
    && curl -L http://geos.osgeo.org/snapshots/geos-`date -d yesterday +%Y%m%d`.tar.bz2 | tar xj --strip-components=1 -C /tmp/geos \
    && cd /tmp/geos \
    && ./configure && make && make install \
    \
    && curl -L http://postgis.net/stuff/postgis-$POSTGIS_VERSION.tar.gz | tar xz --strip-components=1 -C /tmp/postgis \
    && cd /tmp/postgis/ \
    && ./configure && make && make install && ldconfig && make comments-install \
    \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*
