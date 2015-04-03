FROM debian:stable

MAINTAINER Anh K. Huynh <kyanh@theslinux.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y build-essential libpcre3-dev
RUN apt-get install -y git
RUN apt-get install -y nginx

RUN apt-get install -y libssl-dev
RUN mkdir -pv /usr/src/build/

RUN wget https://github.com/openresty/echo-nginx-module/archive/v0.57.tar.gz \
      -O /usr/src/echo-nginx-module-v0.57.tar.gz
RUN wget https://github.com/openresty/headers-more-nginx-module/archive/v0.25.tar.gz \
      -O /usr/src/headers-more-nginx-module-v0.25.tar.gz

ENV NGINX_VERSION 1.6.2
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
      -O /usr/src/nginx-${NGINX_VERSION}.tar.gz

ADD build.sh /usr/src/build/
RUN chmod 700 /usr/src/build/build.sh
RUN cd /usr/src/build && ./build.sh
RUN mkdir -pv /var/www/internal/
RUN rm -rf /etc/nginx/
RUN mkdir /etc/nginx/
ADD etc/nginx/ /etc/nginx/
RUN /usr/sbin/nginx -t
RUN /usr/sbin/nginx -V

ADD nginx.sh /
RUN chmod 700 /nginx.sh
EXPOSE 80

CMD ["/nginx.sh"]
