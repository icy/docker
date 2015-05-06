FROM icy/supervisor:latest

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install -y openjdk-7-jre \
  && apt-get install -y tomcat7 \
  && apt-get install -y tomcat7-admin \
  && rm -fv /var/cache/apt/*.bin \
  && rm -fv /var/cache/apt/archives/*.* \
  && rm -fv /var/lib/apt/lists/*.* \
  && apt-get autoclean \
  && mkdir -pv /tomcat/webapps/ /tomcat/work/ /tomcat/logs/ \
  && ln -s /usr/share/tomcat7-admin/manager/ /tomcat/webapps/ \
  && ln -s /usr/share/tomcat7-admin/host-manager/ /tomcat/webapps/ \
  && ln -s /usr/share/tomcat7/lib/ /tomcat/lib \
  && mv /etc/tomcat7/ /tomcat/conf \
  && useradd -K UID_MIN=10000 tomcat \
  && chown root:tomcat /tomcat/ \
  && chown -R root:tomcat /tomcat/conf/ \
  && chown tomcat:tomcat /tomcat/work/ /tomcat/logs/ \
  && ln -s /tomcat/ /home/tomcat

VOLUME /tomcat/logs/
VOLUME /tomcat/webapps/
VOLUME /tomcat/conf/
VOLUME /etc/s.supervisor/

EXPOSE 8080
CMD ["/supervisor.sh"]
