FROM icy/supervisor:latest

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

RUN mkdir /home/phantomjs
RUN chown phantomjs:phantomjs /home/phantomjs

RUN apt-get install -y fontconfig

ADD /phantomjs.sh /etc/s.supervisor/
RUN chmod -c 755 /etc/s.supervisor/phantomjs.sh

EXPOSE 8190
VOLUME /usr/share/fonts/

CMD ["/supervisor.sh"]
