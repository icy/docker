#!/bin/bash

exec \
  /usr/bin/java \
  $TOMCAT_EXTRA \
  -Dfile.encoding=UTF-8 \
  -Djava.util.logging.config.file=/tomcat/conf/logging.properties \
  -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
  -Djava.endorsed.dirs=/usr/share/tomcat7/endorsed \
  -classpath /usr/share/tomcat7/bin/bootstrap.jar:/usr/share/tomcat7/bin/tomcat-juli.jar \
  -Dcatalina.base=/tomcat/ \
  -Dcatalina.home=/tomcat/ \
  -Djava.io.tmpdir=/tmp/ \
  org.apache.catalina.startup.Bootstrap start
