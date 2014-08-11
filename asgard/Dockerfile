FROM conjurinc/webservice
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

RUN apk update
RUN apk add openjdk7-jre-base

ADD https://netflixoss.ci.cloudbees.com/job/asgard-master/lastStableBuild/artifact/asgard-standalone.jar /opt/asgard/asgard-standalone.jar

COPY etc-asgard /etc/asgard
COPY launch /etc/scripts/
COPY conjur.container /etc/

EXPOSE 80
