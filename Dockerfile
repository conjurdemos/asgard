FROM paulczar/asgard
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

ADD https://s3.amazonaws.com/conjur-releases/omnibus/conjur_4.10.1-2_amd64.deb /tmp/conjur.deb
RUN dpkg -i /tmp/conjur.deb
RUN rm /tmp/conjur.deb
