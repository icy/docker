FROM debian:stable

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y bzip2

RUN cd /usr/ \
    && curl -Lso- \
      https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 \
    | tar -xjf - \
        phantomjs-1.9.8-linux-x86_64/bin/phantomjs \
        --strip-components=1

RUN useradd phantomjs
RUN chmod 755 /usr/bin/phantomjs

ADD phantomjs.sh /
RUN chmod 755 /phantomjs.sh

RUN mkdir /home/phantomjs
RUN chown phantomjs:phantomjs /home/phantomjs

RUN apt-get install -y fontconfig

EXPOSE 8190
VOLUME /usr/share/fonts/

USER phantomjs
CMD ["/phantomjs.sh"]
