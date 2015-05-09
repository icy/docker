#!/bin/bash

if [[ "${CRON_ENABLE:-0}" == "0" ]]; then
  rm -f /etc/s.supervisor/cron.s
  exit 0
fi

if [[ "${1:-}" == "start" ]]; then
  exec /usr/sbin/cron -f -x ${CRON_LOGLEVEL:-bit}
  :
fi

########################################################################
# Configuration generator
########################################################################

cat \
  > /etc/s.supervisor/cron.s \
<<EOF
[program:cron]
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
stdout_logfile=/supervisor/cron.log
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
