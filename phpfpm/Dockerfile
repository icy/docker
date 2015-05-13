FROM icy/nginx:latest

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV DEBIAN_FRONTEND noninteractive
ENV PHP5_PACKAGES php5-mysql php5-curl php5-gd php5-cgi php-mail php5-fpm

RUN set -x \
  && apt-get update \
  && apt-get install -y $PHP5_PACKAGES \
  && mkdir -p /phpfpm/www/ /phpfpm/var/ /phpfpm/logs/ \
  \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean

ADD phpfpm.conf.default /phpfpm/
ADD supervisor/*.sh /etc/s.supervisor/

VOLUME /phpfpm/www/

CMD ["/supervisor.sh"]
