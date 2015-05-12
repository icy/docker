#!/bin/bash

# Purpose: Build and install nginx from source
# Author : Anh K. Huynh
# Date   : 2012 April 10, 2013 Jan 10, 2015 Apr 3
# License: Fair license

set -x

_NGINX_NAME="nginx-${NGINX_VERSION}"
_NGINX_FLAGS="
    --prefix=/usr/ \
    --conf-path=/etc/nginx/nginx.conf
    --http-log-path=/var/log/nginx/access.log
    --error-log-path=/var/log/nginx/error.log
    --lock-path=/var/lock/nginx.lock
    --pid-path=/run/nginx.pid
    --http-client-body-temp-path=/var/lib/nginx/body
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi
    --http-proxy-temp-path=/var/lib/nginx/proxy
    --http-scgi-temp-path=/var/lib/nginx/scgi
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi
    --with-pcre
    --with-http_ssl_module
    --with-http_stub_status_module
    --with-http_realip_module
    --with-http_gzip_static_module
    --with-http_sub_module
  "

_NONSTANDARD_MODULES=""

_D_BUILD="/usr/src/build/"

_NONSTANDARD_MODULES="$( \
  find $_D_BUILD/modules/ \
        -mindepth 1 -maxdepth 1 -type d \
    | while read _d; do \
        echo -en " --add-module=$_d"; \
      done)"

cd $_D_BUILD/$_NGINX_NAME
sed -i -e 's# bgcolor=\\"white\\"##g' \-e 's#<center><h1>##g' \
  -e 's#</h1></center>##g' -e '/NGINX_VER/d' -e '/>nginx</d' \
  ./src/http/ngx_http_special_response.c

sh configure \
  $_NGINX_FLAGS \
  $_NONSTANDARD_MODULES

make
make install
