#!/bin/bash

set -e

if [[ "${1:-}" == "start" ]]; then
  exec /usr/sbin/php5-fpm -F -y /phpfpm/phpfpm.conf
  :
fi

########################################################################
# Configuration generation
########################################################################

_nginx_config_default() {
  cat \
<<-EOF
  server {
    listen       80;
    server_name  ${PHPFPM_DOMAIN} ${PHPFPM_OTHER_DOMAINS:-};
    root         /phpfpm/www/;

    index index.php index.html;

    error_log   /var/log/nginx/${PHPFPM_DOMAIN}.error.log;
    access_log  /var/log/nginx/${PHPFPM_DOMAIN}.acces.log main;

    include /etc/nginx/misc/security.conf;

    location ~ \.php$ {
      fastcgi_pass     unix:/phpfpm/var/phpfpm.sock;
      fastcgi_index    index.php;
      fastcgi_param    SCRIPT_FILENAME  /phpfpm/www/\$fastcgi_script_name;
      include          /etc/nginx/fastcgi_params;
    }
  }
EOF
}

export  PHPFPM_DOMAIN="${PHPFPM_DOMAIN:-$(hostname -f ||  hostname)}"

########################################################################
# Generating nginx configuration
########################################################################

_F_CONFIG="/etc/nginx/sites/phpfpm.conf"
if [[ ! -f "$_F_CONFIG" ]]; then
  echo >&2 ":: Warning: Generating $_F_CONFIG)..."
  _nginx_config_default > $_F_CONFIG
fi

########################################################################
# Generating php-fpm configuration
########################################################################

_F_CONFIG="/phpfpm/phpfpm.conf"
if [[ ! -f $_F_CONFIG ]]; then
  echo >&2 ":: Using the default configuration file..."
  cp -fv $_F_CONFIG.default $_F_CONFIG
fi

########################################################################
# Running hooks
########################################################################

while read FILE; do
  chmod -c 755 "$FILE" # FIXME: This is a Docker bug!
  bash -n "$FILE" \
  && {
    echo >&2 ":: phpfpm:: Executing hook with '$FILE phpfpm_hook'..."
    "$FILE" phpfpm_hook
  } \
  || true
done \
< <(find /etc/s.supervisor/ -type f -iname "phpfpm_*.sh" | sort)

########################################################################
# Fix chmod
########################################################################

mkdir -pv /phpfpm/var/ /phpfpm/logs/
chown -c www-data:www-data /phpfpm/var/ /phpfpm/logs/
chmod -c 750 /phpfpm/var/ /phpfpm/logs/

########################################################################
# Generating Supervisor configuration
########################################################################

cat \
  > /etc/s.supervisor/phpfpm.s \
<<EOF
[program:phpfpm]
command=$0 start
process_name=%(program_name)s
numprocs=1
directory=/
umask=022
priority=999
autostart=true
autorestart=true
startsecs=1
startretries=3
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10
user=www-data
redirect_stderr=true
stdout_logfile=/supervisor/phpfpm.log
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=10
stdout_capture_maxbytes=0
stdout_events_enabled=false
stderr_logfile=AUTO
stderr_logfile_maxbytes=50MB
stderr_logfile_backups=10
stderr_capture_maxbytes=0
stderr_events_enabled=false
environment=
EOF
