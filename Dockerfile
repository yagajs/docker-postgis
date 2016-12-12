# vim:set ft=dockerfile:

FROM postgres:9.4

MAINTAINER Arne Schubert, atd.schubert@gmail.com

RUN set -x \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y postgis postgresql-9.4-postgis-2.1

