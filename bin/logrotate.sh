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

      _rotate_files() {
        local _file

        while (( $# )); do
          _file="$1"; shift

          if [[ ! -f "$_file" ]]; then
            continue
          fi

          if [[ -L "$_file" ]]; then
            continue
          fi

          # If the file is less than 1024 bytes
          if [[ "$(stat -c %s "$_file")" -le 1024 ]]; then
            continue
          fi

          mv -v "$_file" "$_file-$SUFFIX"
        done
      }

      _has_process nginx && {
        _reg_dir /var/log/nginx/

        _rotate_files \
          /var/log/nginx/error.log \
          /var/log/nginx/acces.log

        kill -USR1 $(s pid nginx)

        find /var/log/nginx/ -type f -iname "*.log-*" -a ! -iname "*.gz" -mmin +1439 -exec gzip {} \;
      }

      _has_process apache && {
        _reg_dir /var/log/apache2/

        _rotate_files \
          /var/log/apache2/error.log \
          /var/log/apache2/acces.log

        kill -USR1 $(s pid apache)

        find /var/log/apache2/ -type f -iname "*.log-*" -a ! -iname "*.gz" -mmin +1439 -exec gzip {} \;
      }

      _has_process exim4 && {
        _reg_dir /var/log/exim4/

        for FILE in mainlog rejectlog paniclog; do
          _rotate_files /var/log/exim4/$FILE

          # Make sure future file is readable by fluentd ~~~
          touch /var/log/exim4/$FILE
          chown Debian-exim /var/log/exim4/$FILE
          chmod 644 /var/log/exim4/$FILE
        done

        # Rotate any mail files under /var/mail/.
        # NOTE: Email daemon will create new file automatically
        find /var/mail/ -type f ! -iname "*.gz " -a ! -iname "*[0-9][0-9][0-9][0-9]" \
        | while read FILE; do
            _rotate_files "$FILE"
          done

        find /var/log/exim4/ -type f -iname "*log-*" -a ! -iname "*.gz" -mmin +1439 -exec gzip {} \;
        find /var/mail/ -type f -iname "*[0-9][0-9][0-9][0-9]" -mmin +1439 -exec gzip {} \;
      }

      # MySQL just makes life harder
      # https://www.percona.com/blog/2014/11/12/log-rotate-and-the-deleted-mysql-log-file-mystery/

      _has_process mysql && {
        _reg_dir /var/log/mysql/

        find /var/log/mysql/ -type f -iname "*.log" \
        | while read FILE; do
            _rotate_files "$FILE"

            #
            touch "$FILE"
            chown mysql:adm "$FILE"
            chmod 640 "$FILE"
          done

        mysql -B -e \
          " select @@global.long_query_time into @lqt_save;
            select @@global.slow_query_log  into @sql_save;
            set global long_query_time=2000;
            set global slow_query_log = 0;
            select sleep(2);
            FLUSH LOGS;
            select sleep(2);
            set global long_query_time=@lqt_save;
            set global slow_query_log=@sql_save;
          "

        find /var/log/mysql/ -type f -iname "*.log-*" -a ! -iname "*.gz" -mmin +1439 -exec gzip {} \;
      }

      _has_process solr && {
        _reg_dir /opt/solor/example/logs/

        find /opt/solr/example/logs/ -type f -iname "*.log" -mmin +1439 -exec gzip {} \;
      }

      _has_process tomcat && {
        _reg_dir /tomcat/logs/

        find /tomcat/logs/ -type f -iname "catalina*.log" -mmin +1439 -exec gzip {} \;
        find /tomcat/logs/ -type f -iname "localhos*.log" -mmin +1439 -exec gzip {} \;
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
