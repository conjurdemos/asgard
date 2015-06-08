FROM uggedal/alpine

RUN apk update
RUN apk add openjdk7-jre-base

ADD https://netflixoss.ci.cloudbees.com/job/asgard-master/lastStableBuild/artifact/asgard-standalone.jar /opt/asgard/asgard-standalone.jar

COPY etc /etc/asgard
COPY launch /opt/

EXPOSE 80

CMD ["/opt/launch"]
