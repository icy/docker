FROM debian:stable

MAINTAINER Anh K. Huynh <kyanh@theslinux.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y wget

RUN apt-get install -y libxcursor1 libxext6 libxau6 libxdmcp6 libxrender1 \
  libxrandr2 libfreetype6  libfontconfig1 libexpat1 libpng12-0 libsm6 libice6

RUN apt-get install -y \
  libxi6 libglib2.0-0 libgl1-mesa-glx libglu1-mesa

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y ia32-libs

RUN apt-get install -y openssh-server
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config
RUN mkdir -p /var/run/sshd

RUN apt-get install -y locales
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true

RUN useradd -m -d /home/aftershot/ aftershot
RUN echo 'aftershot:aftershot' | chpasswd
RUN mkdir -pv /home/aftershot/.config/Corel/ /home/aftershot/.AfterShotPro/

RUN mkdir -pv /usr/src/
RUN echo /opt/AfterShotPro/lib/ > /etc/ld.so.conf.d/aftershot.conf

RUN wget http://dwnld.aftershotpro.com/AfterShot/Patch/1/1_2/AfterShotPro_amd64.deb -O /usr/src/AfterShot-1.2.0.7.deb
RUN dpkg -i /usr/src/AfterShot-1.2.0.7.deb
RUN ldconfig

RUN rm -fv /usr/src/AfterShot-1.2.0.7.deb
RUN rm -fv /var/cache/apt/*.bin
RUN rm -fv /var/cache/apt/archives/*.*
RUN rm -fv /var/lib/apt/lists/*.*
RUN apt-get autoclean

EXPOSE 22

ADD sshd.sh /
RUN chmod 700 /sshd.sh
CMD ["/sshd.sh"]
