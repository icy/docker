FROM icy/supervisor:latest

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install -y curl \
  && apt-get install -y bzip2 \
  && apt-get install -y fontconfig \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean \
  && cd /usr/ \
  && curl -Lso- \
    https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 \
  | tar -xjf - \
      phantomjs-1.9.8-linux-x86_64/bin/phantomjs \
      --strip-components=1 \
  && useradd -K UID_MIN=10001 phantomjs \
  && chmod 755 /usr/bin/phantomjs \
  && mkdir /home/phantomjs \
  && chown phantomjs:phantomjs /home/phantomjs

EXPOSE 8190
VOLUME /usr/share/fonts/
VOLUME /etc/s.supervisor/

CMD ["/supervisor.sh"]
