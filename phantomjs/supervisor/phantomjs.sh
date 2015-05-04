#!/bin/bash

if [[ "${1:-}" == "start" ]]; then
  fc-cache
  exec /usr/bin/phantomjs --webdriver=8190 --debug=${PHANTOMJS_DEBUG:-false}
  :
fi


cat \
  > /etc/s.supervisor/phantomjs.s \
<<EOF
[program:phantomjs]
command=$0 start
process_name=%(program_name)s
numprocs=1
directory=/home/phantomjs/
umask=022
priority=999
autostart=true
autorestart=true
startsecs=1
startretries=3
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10
user=phantomjs
redirect_stderr=true
stdout_logfile=/supervisor/phantomjs.log
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
