FROM debian:wheezy

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
  && apt-get update \
  && apt-get install -y \
      supervisor cron exim4-daemon-light \
  \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean \
  \
  && rm -rf /etc/supervisor/ \
  && mkdir -pv /etc/s.supervisor/ /supervisor/ \
  && ln -s /usr/bin/supervisorctl /usr/bin/s \
  \
  && chmod -s /var/log/exim4/

RUN set -x \
  && _tmp_pkgs='python-setuptools curl ca-certificates' \
  && apt-get update \
  && apt-get install -y $_tmp_pkgs --no-install-recommends \
  \
  && curl -Lso /usr/bin/syslog-stdout.py \
      https://raw.githubusercontent.com/icyfork/syslog-stdout/master/syslog-stdout.py \
  \
  && mkdir -pv /usr/src/pip/ \
  && cd /usr/src/pip/ \
  && curl -Lso - \
      https://github.com/icyfork/supervisor-stdout/archive/master.tar.gz \
      | tar -xzf - -C /usr/src/pip/ --strip-components=1 \
  && python2 setup.py install \
  \
  && cd / \
  && rm -r /usr/src/pip/ \
  && apt-get purge -y --auto-remove $_tmp_pkgs \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean

# RUN set -x \
#   && echo 'LANG="en_US.UTF-8"' > /etc/default/locale
#   && _tmp_pkgs='locale-purge' \
#   && apt-get update \
#   && apt-get install -y $_tmp_pkgs --no-install-recommends \
#   && echo -e "MANDELETE\nDONTBOTHERNEWLOCALE\nVERBOSE\nen_US\nen_US.UTF-8" \
#     > /etc/locale.nopurge \
#   && localepurge \
#   && rm -rf /usr/share/doc/ \
#   \
#   && apt-get purge -y --auto-remove $_tmp_pkgs \
#   && rm -fv /var/cache/apt/*.bin \
#   && rm -fv /var/cache/apt/archives/*.* \
#   && rm -fv /var/lib/apt/lists/*.* \
#   && apt-get autoclean

ADD supervisor.sh /
RUN chmod 700 /supervisor.sh

ADD supervisor/*.sh supervisor/*.s /etc/s.supervisor/

VOLUME /supervisor/
VOLUME /var/log/exim4/

ONBUILD COPY supervisor/*.sh supervisor/*.s /etc/s.supervisor/
ONBUILD COPY cron.d/* /etc/cron.d/

CMD ["/supervisor.sh"]
