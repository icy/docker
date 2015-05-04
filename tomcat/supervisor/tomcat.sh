#!/bin/bash

set -e

if [[ "${1:-}" == "start" ]]; then
  if [[ -n "$TOMCAT_UID" ]]; then
    usermod -u "$TOMCAT_UID" tomcat
  fi

  if [[ -n "$TOMCAT_GID" ]]; then
    groupmod -u "$TOMCAT_GID" tomcat
  fi

  exec \
    /usr/bin/java \
    $TOMCAT_EXTRA \
    -Dfile.encoding=UTF-8 \
    -Djava.util.logging.config.file=/tomcat/conf/logging.properties \
    -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
    -Djava.endorsed.dirs=/usr/share/tomcat7/endorsed \
    -classpath /usr/share/tomcat7/bin/bootstrap.jar:/usr/share/tomcat7/bin/tomcat-juli.jar \
    -Dcatalina.base=/tomcat/ \
    -Dcatalina.home=/tomcat/ \
    -Djava.io.tmpdir=/tmp/ \
    org.apache.catalina.startup.Bootstrap start
  :
fi


cat \
  > /etc/s.supervisor/tomcat.s \
<<EOF
[program:tomcat]
command=$0 start
process_name=%(program_name)s
numprocs=1
directory=/tomcat/
umask=022
priority=999
autostart=true
autorestart=true
startsecs=1
startretries=3
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10
user=tomcat
redirect_stderr=true
stdout_logfile=/supervisor/tomcat.log
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
