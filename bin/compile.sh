#!/usr/bin/env bash

# Purpose : A simple script to compile Bocker itesm
# Syntax  : $0 ITEM1 ITEM2...
# Author  : Ky-Anh Huynh
# License : Mit
# Date    : 2015

D_ROOT="$(dirname "${BASH_SOURCE[0]:-.}")/../"

ITEMS="${ITEMS:-$*}"

if [[ -z "${ITEMS:-}" ]]; then
  FILES="$(\ls bocker/Bockerfile.*)"
else
  FILES="$(for _ in $ITEMS; do echo bocker/Bockerfile.$_; done)"
fi

for f in $FILES; do
  _name="$(echo $f | awk -F . '{print $NF}')"

  case $_name in
  base|cron|exim4|elasticsearch17|msyslog|base_slitaz|slitaz_base)
    continue;;
  esac

  echo ":: -> $f"
  ./compiler/bocker.sh $f \
    > context/Dockerfile.$_name || exit 1
done
