FROM debian:wheezy

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
  && apt-get update \
  && apt-get install -y \
      supervisor cron exim4-daemon-light \
  \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean \
  \
  && rm -rf /etc/supervisor/ \
  && mkdir -pv /etc/s.supervisor/ /supervisor/ \
  && ln -s /usr/bin/supervisorctl /usr/bin/s \
  \
  && chmod -s /var/log/exim4/

RUN set -x \
  && apt-get update \
  && _tmp_pkgs='curl gcc libc6-dev make patch ca-certificates' \
  && apt-get update \
  && apt-get install -y $_tmp_pkgs --no-install-recommends \
  \
  && mkdir -pv /usr/src/cron \
  && cd /usr/src/cron \
  && curl -sSL -o cron.tar.gz \
      "http://http.debian.net/debian/pool/main/c/cron/cron_3.0pl1.orig.tar.gz" \
  && curl -sSL -o diff.gz \
      "http://http.debian.net/debian/pool/main/c/cron/cron_3.0pl1-124.diff.gz" \
  && echo "f8d00de4c7c0eae97bedb4a3ec10ea21d43ece84 *cron.tar.gz" \
      | sha1sum -c - \
  && echo "d9d45f55cef431e3b3e0e5e9d86d75749287ffa8 *diff.gz" \
      | sha1sum -c - \
  && tar -xzf cron.tar.gz -C /usr/src/cron --strip-components=1 \
  && zcat diff.gz \
      | patch -Np1 \
  \
  && echo "#define DEBUGGING 1" >> /usr/src/cron/config.h \
  && sed -i -e 's|#define DEBUGGING.*$|#define DEBUGGING 1|g' /usr/src/cron/cron.h \
  && curl -Lso- https://raw.githubusercontent.com/icy/docker/master/supervisor/misc.c.patch \
    | patch -Np1 \
  \
  && make \
  && install -s -c -m  755 -o root cron    /usr/sbin/ \
  && install -s -c -m 4755 -o root crontab /usr/bin/ \
  \
  && cd / \
  && rm -r /usr/src/cron \
  && apt-get purge -y --auto-remove $_tmp_pkgs \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean

ADD supervisor.sh /
RUN chmod 700 /supervisor.sh

ADD supervisor/*.sh supervisor/*.s /etc/s.supervisor/

VOLUME /supervisor/
VOLUME /var/log/exim4/

ONBUILD COPY supervisor/*.sh supervisor/*.s /etc/s.supervisor/
ONBUILD COPY cron.d/* /etc/cron.d/

CMD ["/supervisor.sh"]
