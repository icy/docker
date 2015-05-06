FROM debian:wheezy

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install -y supervisor \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean \
  && rm -rf /etc/supervisor/ \
  && mkdir -pv /etc/s.supervisor/ /supervisor/

ADD supervisor.sh /
RUN chmod 700 /supervisor.sh

# EXPOSE 9001
VOLUME /supervisor/
VOLUME /etc/s.supervisor/

ONBUILD COPY supervisor/*.sh supervisor/*.s /etc/s.supervisor/

RUN ln -s /usr/bin/supervisorctl /usr/bin/s

CMD ["/supervisor.sh"]
