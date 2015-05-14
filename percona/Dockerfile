# Based on
#  https://github.com/docker-library/percona/tree/master/5.6

FROM icy/supervisor:latest
MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV DEBIAN_FRONTEND noninteractive

ENV PERCONA_MAJOR 5.6
# ENV PERCONA_VERSION 5.6.23-72.1-1.wheezy

RUN set -x \
  && apt-key adv \
      --keyserver keys.gnupg.net \
      --recv-keys 430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A \
  && echo 'deb http://repo.percona.com/apt wheezy main' \
      > /etc/apt/sources.list.d/percona.list \
  && apt-get update \
  && apt-get install -y \
      percona-server-server-$PERCONA_MAJOR \
  \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && rm -rf /var/lib/mysql/ /usr/share/doc/ \
  && apt-get autoclean \
  \
  && mkdir /mysql/ \
  && groupmod -g 10003 mysql \
  && usermod -u 10003 -g 10003 mysql \
  \
  && rm -rf /var/log/mysql/ /var/run/mysqld/ \

EXPOSE 3306
VOLUME /mysql

CMD ["/supervisor.sh"]
