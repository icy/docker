FROM icy/phpfpm:latest

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV WP_VERSION="4.2.2"

VOLUME /phpfpm/www/wp-content/

ADD supervisor/*.sh /etc/s.supervisor/

CMD ["/supervisor.sh"]
