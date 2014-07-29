FROM paulczar/asgard
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

ADD https://s3.amazonaws.com/conjur-releases/omnibus/conjur_4.10.1-2_amd64.deb /tmp/conjur.deb
RUN dpkg -i /tmp/conjur.deb
RUN rm /tmp/conjur.deb

COPY conjur.profile /etc/profile.d/conjur.sh
COPY conjur-configure.sh /opt/conjur/configure
COPY asgard-run.sh /usr/sbin/launch-asgard
COPY asgard.env.yaml /etc/asgard/
COPY asgard.conf.erb /etc/asgard/

CMD ["/usr/sbin/launch-asgard"]
