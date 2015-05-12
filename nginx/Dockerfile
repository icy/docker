FROM icy/supervisor:latest

MAINTAINER Anh K. Huynh <kyanh@theslinux.org>

ENV DEBIAN_FRONTEND noninteractive

ENV NGINX_VERSION 1.8.0
ENV NGINX_CHECKSUM 12bad312764feae50246685ab2e74512d1aa9b2f

RUN set -x \
  && apt-get update \
  && apt-get install -y \
        curl gcc libc6-dev make curl libpcre3-dev git nginx libssl-dev \
  && mkdir -pv /usr/src/build/modules/ \
  && cd /usr/src/build/ \
  && curl -Lso- https://github.com/openresty/echo-nginx-module/archive/v0.57.tar.gz \
      | tar -xzf - -C /usr/src/build/modules/ \
  && curl -Lso- https://github.com/openresty/headers-more-nginx-module/archive/v0.25.tar.gz \
      | tar -xzf - -C /usr/src/build/modules/ \
  && curl -Lso /usr/src/build/nginx.tar.gz \
      http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && echo "$NGINX_CHECKSUM *nginx.tar.gz" | sha1sum -c - \
  && tar -xzf nginx.tar.gz -C /usr/src/build/

ADD build.sh /usr/src/build/
ADD nginx.sh /

RUN set -x \
  && chmod 700 /nginx.sh \
  && bash /usr/src/build/build.sh \
  \
  && cd / \
  && rm -rf /usr/src/ /etc/nginx/ \
  && mkdir -pv /var/www/internal/ \
  && mkdir /etc/nginx/ \
  \
  && apt-get purge -y --auto-remove curl gcc libc6-dev make curl git \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean

ADD etc/nginx/ /etc/nginx/

EXPOSE 80
CMD ["/nginx.sh"]
