#!/bin/bash

if [[ -z "$_UID" || -z "$_GID" ]]; then
  echo >&2 ":: You must specifiy _UID and _GID when executing 'docker run'"
  exit 1
fi

groupmod -g $_GID aftershot
usermod -u $_UID -g $_GID aftershot

exec /usr/sbin/sshd -D
