FROM uggedal/alpine

RUN apk update
RUN apk add openjdk7-jre-base

ADD https://netflixoss.ci.cloudbees.com/job/asgard-master/lastStableBuild/artifact/asgard-standalone.jar /opt/asgard/asgard-standalone.jar

COPY etc-asgard /etc/asgard
COPY launch /etc/scripts/

EXPOSE 80
