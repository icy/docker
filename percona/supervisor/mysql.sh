#!/bin/bash

set -e

# As Root
_mysql_datadir() {
  if [[ "$UID" == 0 ]]; then
    if [[ -f "/mysql/my.cnf" ]]; then
      echo >&2 ":: MySQL: /mysql/my.conf found. Copying it to /etc/mysql/my.conf"
      cp -vf /mysql/my.cnf /etc/mysql/my.cnf || return 1
    fi

    echo >&2 ":: MySQL: Fix bind-address..."
    sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf

    echo >&2 ":: MySQL: Fix datadir setting in /etc/mysql/my.cnf"
    sed -i \
      -e 's#datadir[[:space:]]*=.*$#datadir = /mysql/#g' \
      /etc/mysql/my.cnf
  fi

  _D_DATA="$(/usr/sbin/mysqld --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"
  if [[ "$_D_DATA" != "/mysql/" ]]; then
    echo >&2 ":: MySQL: data directory must be /mysql/. Current value: $_D_DATA."
    return 1
  fi

  echo "$_D_DATA"
}

# as MySQL
_mysql_init() {
  _D_DATA="$(_mysql_datadir)" || exit 1

  if [[ -d "/mysql/mysql/" ]]; then
    return 0
  fi

  local _f_init='/mysql/docker-init.sql'
  local _f_0run='/mysql/docker.first.run'

  if [[ -f "$_f_init" ]]; then
    return 0
  fi

  echo >&2 ":: MySQL: Unable to locate the base data directory /mysql/mysql/."
  echo >&2 ":: MySQL: Going to initialize a new database set."

  if [[ -z "$MYSQL_ROOT_PASSWD" ]]; then
    MYSQL_ROOT_PASSWD="#$RANDOM#$RANDOM#"
    echo >&2 ":: MySQL: No password is provided. A random password will be used."
    echo >&2 ":: MySQL: You can find this password in '$_f_init'."
  fi

  echo >&2 ':: MySQL: Running mysql_install_db...'
  mysql_install_db --datadir="/mysql/"
  echo >&2 ':: MySQL: Finished mysql_install_db.'

  touch /mysql/docker-init.sql
  chmod 600 /mysql/docker-init.sql

  cat > "$_f_init" \
<<-EOSQL
    DELETE FROM mysql.user;
    CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWD}' ;
    GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
    DROP DATABASE IF EXISTS test ;
    FLUSH PRIVILEGES ;
EOSQL

  echo > "$_f_0run"
}

########################################################################
# Start-up script
########################################################################

case "${1:-}" in
  "start")
    if [[ -f "/mysql/docker-init.sql" \
        && -f "/mysql/docker.first.run" ]]; then

      rm -f /mysql/docker.first.run
      exec /usr/sbin/mysqld --init-file=/mysql/docker-init.sql
    fi

    exec /usr/sbin/mysqld;
    exit;
    ;;

  "init")
    _mysql_init;
    exit;
    ;;
esac

########################################################################
# Supervisor generator
########################################################################

_D_DATA="$(_mysql_datadir)" || exit 1
mkdir -pv /var/run/mysqld/ /var/log/mysql/
chown -R mysql:mysql /mysql/ /var/run/mysqld/ /var/log/mysql/

# initialize the database if necessary
su mysql -s /bin/bash -c "$0 init"
if [[ $? -ge 1 ]]; then
  exit 1
fi

# Percona warning message
cat <<-EOF
~~~~~~~
* Percona Server is distributed with several useful UDF (User Defined Function) from Percona Toolkit.
* Run the following commands to create these functions:

    mysql -e "CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so'"
    mysql -e "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
    mysql -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"

* See http://www.percona.com/doc/percona-server/5.6/management/udf_percona_toolkit.html for more details
~~~~~~~
EOF
# now generator supervisor configuration

cat \
  > /etc/s.supervisor/mysql.s \
<<EOF
[program:mysql]
command=$0 start
process_name=%(program_name)s
numprocs=1
directory=/mysql
umask=022
priority=999
autostart=true
autorestart=true
startsecs=1
startretries=3
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10
user=mysql
redirect_stderr=true
stdout_logfile=/supervisor/mysql.log
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
