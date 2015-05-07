#!/bin/bash

if [[ "${1:-}" == "start" ]]; then
  exec /usr/local/bin/redis-server \
    /redis/redis-${REDIS_MAJOR_VERSION:-2.8}.conf \
    --loglevel "${REDIS_LOGLEVEL:-warning}" \
    --appendonly "${REDIS_APPENDONLY:-yes}"
  :
fi

# FIXME: Because /redis/ is an exportable volume,
# FIXME: auto-uid fix doesn't work.
echo >&2 ":: Warning: Fixing permission of /redis/*"
chown -c redis: /redis/ /redis/*.*

cat \
  > /etc/s.supervisor/redis.s \
<<EOF
[program:redis]
command=$0 start
process_name=%(program_name)s
numprocs=1
directory=/redis/
umask=022
priority=999
autostart=true
autorestart=true
startsecs=1
startretries=3
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10
user=redis
redirect_stderr=true
stdout_logfile=/supervisor/redis.log
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
