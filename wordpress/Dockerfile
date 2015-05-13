FROM icy/phpfpm:latest

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV WP_VERSION="4.2.2"

RUN set -x \
  && apt-get update \
  && apt-get install -y curl \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean

VOLUME /phpfpm/www/wp-content/uploads/

ADD supervisor/*.sh /etc/s.supervisor/

CMD ["/supervisor.sh"]
