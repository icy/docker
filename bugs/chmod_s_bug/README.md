## Description

`devicemapper` and `aufs` behave differently with setgid directory.

The directory `/var/log/exim4` is owned by `Debian-exim:adm`,
and it's `setgid` (aka `chmod g+s`). When `uid/gid` of `Debian-exim`
is updated, the user `Debian-exim` may not be able to write to
`/var/log/exim4/`.

The problem happens only when back-end storage is `aufs`.
Within `devicemapper` back-end, there isn't problem.

## Expected result

The directory `/var/log/exim4` is writable by `Debian-exim` after `uid`
is updated, on both `devicemapper` and `aufs` back-ends.

## Actual result

Within `aufs` back-end, the directory `/var/log/exim4` is not-writable
by `Debian-exim` after `uid` is updated.

## Reproduce the bug

First, switch to `aufs` back-end. Build the container from `debian:wheezy`
and run the final container.

````
$ git clone https://github.com/icy/docker.git
$ cd bugs/chmod_s_bug/
$ docker build -t icy/chmod_s_bug .
$ docker run --rm -ti icy/chmod_s_bug

+ _D_=/var/log/exim4/
+ ls -lad /var/log/exim4//
drwxr-s--- 2 Debian-exim adm 4096 May  8 10:41 /var/log/exim4//
+ groupmod -g 1200 Debian-exim
+ usermod -g 1200 -u 1200 Debian-exim
+ chown Debian-exim:adm -Rc /var/log/exim4/
changed ownership of `/var/log/exim4/' from 101:adm to Debian-exim:adm
+ su - Debian-exim -s /bin/bash -c 'date > //var/log/exim4//good.txt'
No directory, logging in with HOME=/
-su: //var/log/exim4//good.txt: Permission denied
+ ls -lad /var/log/exim4//
drwxr-s--- 2 Debian-exim adm 4096 May  8 10:41 /var/log/exim4//
+ ls -ltr /var/log/exim4//
total 0

````

## Docker environments

See `
