#!/bin/bash

# Purpose: Generating `msyslog` configuration for `superivisor`
# Author : Anh K. Huynh
# Date   : 2015 May 09th

if [[ "${MSYSLOG_ENABLE:-0}" == "0" ]]; then
  rm -f /etc/s.supervisor/msyslog.s
  exit 0
fi

if [[ "${1:-}" == "start" ]]; then
  exec python2 /usr/bin/syslog-stdout.py
  :
fi

cat > /etc/s.supervisor/msyslog.s \
<<-EOF
[eventlistener:stdout]
command = supervisor_stdout
buffer_size = 100
events = PROCESS_LOG
result_handler = supervisor_stdout:event_handler
priority = 1

[program:msyslog]
command=$0 start
stdout_events_enabled = true
stderr_events_enabled = true
priority = 10
EOF
