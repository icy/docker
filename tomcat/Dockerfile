FROM debian:stable

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

ENV DEBIAN_FRONTEND noninteractive

# --force-yes is required for tzdata-java package

RUN apt-get update
RUN apt-get install -y openjdk-7-jre
RUN apt-get install -y tomcat7
RUN apt-get install -y tomcat7-admin

RUN mkdir -pv /tomcat/webapps/ /tomcat/work/ /tomcat/logs/

RUN ln -s /usr/share/tomcat7-admin/manager/ /tomcat/webapps/
RUN ln -s /usr/share/tomcat7-admin/host-manager/ /tomcat/webapps/
RUN ln -s /usr/share/tomcat7/lib/ /tomcat/lib

RUN mv /etc/tomcat7/ /tomcat/conf

RUN useradd tomcat
RUN chown root:tomcat /tomcat/
RUN chown -R root:tomcat /tomcat/conf/
RUN chown tomcat:tomcat /tomcat/work/ /tomcat/logs/

RUN ln -s /tomcat/ /home/tomcat

ADD ./tomcat.sh /
RUN chmod 755 /tomcat.sh

VOLUME /tomcat/logs/
VOLUME /tomcat/webapps/
VOLUME /tomcat/conf/

EXPOSE 8080

USER tomcat
CMD ["/tomcat.sh"]
