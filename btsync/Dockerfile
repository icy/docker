FROM debian:stable

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"
ENV DEBIAN_FRONTEND noninteractive

# http://syncapp.bittorrent.com/1.3.109/btsync_x64-1.3.109.tar.gz
RUN apt-get update
RUN apt-get install -y curl
RUN cd /usr/bin/ \
  && curl -Ls http://syncapp.bittorrent.com/1.3.109/btsync_x64-1.3.109.tar.gz \
    | tar -xzf - btsync

EXPOSE 8888
EXPOSE 8889

RUN useradd btsync
RUN mkdir -pv /home/btsync/var/ /home/btsync/sync/
RUN chown btsync:btsync -R /home/btsync

ADD btsync.sh /
RUN chmod 755 /btsync.sh

VOLUME /home/btsync/
USER btsync
CMD ["/btsync.sh"]
