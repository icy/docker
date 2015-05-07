FROM debian:wheezy

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install -y supervisor cron \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean \
  && rm -rf /etc/supervisor/ \
  && mkdir -pv /etc/s.supervisor/ /supervisor/ \
  && ln -s /usr/bin/supervisorctl /usr/bin/s

ADD supervisor.sh /
RUN chmod 700 /supervisor.sh

ADD supervisor/cron.sh /etc/s.supervisor/

VOLUME /supervisor/

ONBUILD COPY supervisor/*.sh supervisor/*.s /etc/s.supervisor/
ONBUILD COPY cron.d/* /etc/cron.d/

CMD ["/supervisor.sh"]
