#!/bin/bash

/usr/sbin/nginx -t -c /etc/nginx/nginx.conf || exit 1
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf
