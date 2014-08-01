FROM uggedal/alpine
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

RUN apk update
RUN apk add openjdk7-jre-base ruby nginx-lua ruby-json ruby-bigdecimal
RUN gem install -N conjur-cli

ADD https://netflixoss.ci.cloudbees.com/job/asgard-master/lastStableBuild/artifact/asgard-standalone.jar /opt/asgard/asgard-standalone.jar
