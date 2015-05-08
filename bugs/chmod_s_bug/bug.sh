#!/bin/bash

set -x

_D_=/var/log/exim4/

ls -lad "$_D_/"

groupmod -g 1200 Debian-exim
usermod -g 1200 -u 1200 Debian-exim

chown Debian-exim:adm -Rc "$_D_"

su - Debian-exim -s /bin/bash -c "date > /$_D_/good.txt"

ls -lad "$_D_/"
ls -ltr "$_D_/"
