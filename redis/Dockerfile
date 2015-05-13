FROM icy/supervisor:latest

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

# Based-on Docker's library file
#   https://github.com/docker-library/ \
#   redis/blob/5a480f7c9f05822c31204a7197d209ef9db1a32c/2.8/Dockerfile

ENV DEBIAN_FRONTEND noninteractive

ENV REDIS_MAJOR_VERSION 2.8

ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-2.8.20.tar.gz
ENV REDIS_DOWNLOAD_SHA1 45f134113fb3d75b8c37f7968e46565a70800091

RUN set -x \
  && apt-get update \
  && buildDeps='gcc libc6-dev make' \
  && apt-get install -y $buildDeps --no-install-recommends \
  \
  && mkdir -p /usr/src/redis \
  && curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz \
  && echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" \
      | sha1sum -c - \
  && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
  && rm redis.tar.gz \
  \
  && make -C /usr/src/redis \
  && make -C /usr/src/redis install \
  \
  && rm -r /usr/src/redis \
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean \
  \
  && useradd -K UID_MIN=10002 redis \
  && mkdir /redis \
  && chown redis:redis /redis \
  && ln -s /redis /home/redis

COPY redis-2.8.conf /redis/

VOLUME /redis
EXPOSE 6379

CMD [ "/supervisor.sh" ]
