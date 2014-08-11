FROM conjurinc/webservice
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

RUN apk update
RUN apk add openjdk7-jre-base

ADD http://www.eu.apache.org/dist/tomcat/tomcat-8/v8.0.9/bin/apache-tomcat-8.0.9.tar.gz /tmp/

RUN mkdir -p /opt
RUN tar -zx -C /opt -f /tmp/apache-tomcat-*.tar.gz
RUN ln -sf /opt/apache-tomcat-* /opt/apache-tomcat
RUN rm /tmp/apache-tomcat-*.tar.gz

ADD https://netflixoss.ci.cloudbees.com/job/eureka-master/109/artifact/eureka-server/build/libs/eureka-server-1.1.139-SNAPSHOT.war /opt/apache-tomcat/webapps/eureka.war

COPY launch /etc/scripts/
COPY conjur.container /etc/

EXPOSE 80
