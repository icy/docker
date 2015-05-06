FROM icy/supervisor:latest

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y bzip2
RUN apt-get install -y fontconfig

RUN rm -fv /var/cache/apt/*.bin
RUN rm -fv /var/cache/apt/archives/*.*
RUN rm -fv /var/lib/apt/lists/*.*
RUN apt-get autoclean

RUN cd /usr/ \
    && curl -Lso- \
      https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 \
    | tar -xjf - \
        phantomjs-1.9.8-linux-x86_64/bin/phantomjs \
        --strip-components=1

RUN useradd -K UID_MIN=10001 phantomjs
RUN chmod 755 /usr/bin/phantomjs

RUN mkdir /home/phantomjs
RUN chown phantomjs:phantomjs /home/phantomjs

# ADD phantomjs.sh /etc/s.supervisor/

EXPOSE 8190
VOLUME /usr/share/fonts/
VOLUME /etc/s.supervisor/

CMD ["/supervisor.sh"]
