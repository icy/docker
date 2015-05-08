FROM debian:wheezy
# b3d362b23ec1

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

RUN apt-get update \
  && apt-get install -y \
    exim4-daemon-light \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean

ADD bug.sh /
RUN chmod 755 /bug.sh

CMD ["/bug.sh"]
