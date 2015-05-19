#!/bin/bash

# Purpose: Bocker base support for Debian-base images
# Author : Anh K. Huynh
# Date   : 2015 May 15th

ed_from debian:wheezy
ed_maintainer "Anh K. Huynh <kyanh@theslinux.org>"

ed_ship   ed_apt_clean ed_apt_purge
ed_env    DEBIAN_FRONTEND noninteractive
ed_cmd    '["/supervisor.sh"]'

ed_apt_clean() {
  rm -fv /var/cache/apt/*.bin
  rm -fv /var/cache/apt/archives/*.*
  rm -fv /var/lib/apt/lists/*.*
  apt-get autoclean
}

ed_apt_purge() {
  apt-get purge -y --auto-remove $@
  ed_apt_clean
}
