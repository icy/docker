#!/bin/bash

# Purpose: Simple and Dirty Logrotating for all Docker containers
# Author : Anh K. Huynh
# License: MIT
# Date   : 2015 Nov 24th
# TODO   : Support arbitary log paths

while read CONTAINER; do
  echo >&2 ":: Examine $CONTAINER..."
  docker exec $CONTAINER \
    bash -c '
      which s >/dev/null || exit 0
      SUFFIX="$(date +%Y%m%d.%s)"
      DIRS=""

      _has_process() {
        s pid $1 | grep -qE "^[0-9]+$"
        if [[ $? -eq 0 ]]; then
          echo ":: ... found $1 support"
        else
          return 1
        fi
      }

      _reg_dir() {
        DIRS="$DIRS $@"
      }

      _has_process nginx && {
        _reg_dir /var/log/nginx/

        [[ -f /var/log/nginx/error.log ]] \
          && mv /var/log/nginx/error.log /var/log/nginx/error.log-$SUFFIX

        [[ -f /var/log/nginx/acces.log ]] \
          && mv /var/log/nginx/acces.log /var/log/nginx/acces.log-$SUFFIX

        kill -USR1 $(s pid nginx)

        find /var/log/nginx/ -type f -iname "*.log-*" -mtime +1 -exec gzip {} \;
      }

      _has_process apache && {
        _reg_dir /var/log/apache2/

        [[ -f /var/log/apache2/error.log ]] \
          && mv /var/log/apache2/error.log /var/log/apache2/error.log-$SUFFIX

        [[ -f /var/log/apache2/acces.log ]] \
          && mv /var/log/apache2/acces.log /var/log/apache2/acces.log-$SUFFIX

        kill -USR1 $(s pid apache)

        find /var/log/apache2/ -type f -iname "*.log-*" -mtime +1 -exec gzip {} \;
      }

      _has_process exim4 && {
        _reg_dir /var/log/exim4/

        for FILE in mainlog rejectlog paniclog; do
          [[ -f /var/log/exim4/$FILE ]] \
            && mv /var/log/exim4/$FILE /var/log/exim4/$FILE-$SUFFIX

          # Make sure future file is readable by fluentd ~~~
          touch /var/log/exim4/$FILE
          chown Debian-exim /var/log/exim4/$FILE
          chmod 644 /var/log/exim4/$FILE
        done

        find /var/log/exim4/ -type f -iname "*.log-*" -mtime +1 -exec gzip {} \;
      }

      _has_process solr && {
        _reg_dir /opt/solor/example/logs/

        find /opt/solr/example/logs/ -type f -iname "*.log" -mtime +1 -exec gzip {} \;
      }

      _has_process tomcat && {
        _reg_dir /tomcat/logs/

        find /tomcat/logs/ -type f -iname "catalina*.log"  -mtime +1 -exec gzip {} \;
        find /tomcat/logs/ -type f -iname "localhost*.log" -mtime +1 -exec gzip {} \;
      }

      for _dir in $DIRS; do
        [[ ! -d "$_dir" ]] && continue

        echo >&2 ":: ... clean up $_dir"
        find $_dir \
          -type f -iname "*.gz" -mtime +29 -exec rm -fv {} \;
      done
    '
done < <(
  docker ps \
  | awk '{if (NR>1) {print $NF} }' \
  )
