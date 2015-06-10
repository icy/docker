## Supervisor Buildfile for Docker

`Docker` container naturally contains only one process.
Sometimes, that's good enough. Sometimes, you get a head-ache
with process mangling ([MAKE SURE YOU READ THIS][1]).

So we will run a container that runs multiple processed inside.

The container will have `cron`, `msyslog` and `exim4` daemon disabled by
default. The `logrotate` is installed and will be activated by `cron`.

`msyslog` is the mininum `syslog` implementation by `gryphius` on `Github`.
You may need this to get, e.g, all `cron` information when there isn't
`rsyslog`, `syslog-ng` daemon listening.

## Environments

### Core feature

* `SUPERVISOR_LOG_LEVEL`: Logging level. Default: `info`.
* `FOOBAR_UID=<NUMBER>`: User to create / modify.
* `FOOBAR_GID=<NUMBER>`: Group to create / modify.

You can create/modify `uid/gid` of any user. For example, by specifying
`TOMCAT_UID=1234`, a `tomcat` user will be created and its `uid` is `1234`.

### Msyslog feature

* `MSYSLOG_ENABLE`: Enable the mininum `syslog` implementation. Default: `0`.

### Cron feature

`cron` is disabled by default. When being enabled, `cron` daemon
writes all to `/dev/log`, hence you need `MSYSLOG_ENABLE=1` to see
`cron` verbose information.

* `CRON_ENABLE`: Enable cron daemon. Default: 0
* `CRON_LOGLEVEL`: Cron debugging level. Default: `1`.

### Exim4 feature

* `EXIM4_ENABLE`: Enable Exim4 daemon. Default: 0
* `EXIM4_UID`: The `uid` of `Debian-exim` account. Default: `10004`.
* `EXIM4_GID`: The `gid` of `Debian-exim` account. Default: `10004`.
* `EXIM4_MAILNAME`: The mail name (See `/etc/mailname`). Default: `$HOSTNAME.`
* `EXIM4_OTHER_NAMES`: Other local names (white space list). Default: empty.
* `EXIM4_MINE_CONFIG`: Use your own config mounted on `/etc/mailname`
      and `/etc/exim4/*`. Default: `0`.

## Generators

Before starting the main daemon, the script `/supervisor.sh` will
execute every `*.sh` found under `/etc/s.supervisor/` directory.
The purpose is to create a dynamic configuration for `supervisor`.

The generators will be executed as `root` user, and it can do very
powerful thing. For example, creating new user, fix file permission.
And if you really want to have some hooks, put your code under in a
`Bash` script on host machine and mount that file to a suitable location
under `/etc/s.supervisor/YOUR_SCRIPT.sh`.

You don't need to make generators executable, because they
are actually invoked by `Bash`.

## Logging

All logs are written to `/supervisor/` directory. If you want to
see `cron` logging, or if you application requires `(m)syslog`,
please use `MSYSLOG_ENABLE=1` to capture logs written to `/dev/log`.

Some applications may still write information to standard paths,
e.g, `(Percona) MySQL` will write to `/var/log/mysql/*`.

## Note

To avoid long typing, a symbolic link `/usr/bin/s` is created
for `/usr/bin/supervisorctl`. Now you can type, e.g, `s status`.

[1]: http://web.archive.org/web/20150424090620/https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
