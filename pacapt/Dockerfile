FROM debian:stable
MAINTAINER Anh K. Huynh "kyanh@theslinux.org"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y curl
RUN curl -Lso /usr/bin/pacman https://github.com/icy/pacapt/raw/ng/pacapt
RUN chmod 755 /usr/bin/pacman
