FROM debian:wheezy

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y supervisor

RUN rm -fv /var/cache/apt/*.bin
RUN rm -fv /var/cache/apt/archives/*.*
RUN rm -fv /var/lib/apt/lists/*.*
RUN apt-get autoclean

RUN rm -rf /etc/supervisor/
RUN mkdir -pv /etc/s.supervisor/ /supervisor/

ADD supervisor.sh /
RUN chmod 700 /supervisor.sh

# EXPOSE 9001
VOLUME /supervisor/
VOLUME /etc/s.supervisor/

ONBUILD COPY supervisor/*.sh supervisor/*.s /etc/s.supervisor/

RUN ln -s /usr/bin/supervisorctl /usr/bin/s

CMD ["/supervisor.sh"]
