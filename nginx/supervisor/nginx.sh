#!/bin/bash

if [[ "${1:-}" == "start" ]]; then
  /usr/sbin/nginx -t -c /etc/nginx/nginx.conf || exit 1
  exec /usr/sbin/nginx -c /etc/nginx/nginx.conf
  :
fi

chown -R www-data:www-data /var/lib/nginx

cat \
  > /etc/s.supervisor/nginx.s \
<<EOF
[program:nginx]
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
user=root
redirect_stderr=true
stdout_logfile=/supervisor/nginx.log
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
