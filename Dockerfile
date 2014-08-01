FROM divide/asgard-conjur:base
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

COPY conjur.profile /etc/profile.d/conjur.sh
COPY conjur-configure.sh /opt/conjur/configure
COPY asgard-run.sh /usr/sbin/launch-asgard
COPY asgard.env.yaml /etc/asgard/
COPY asgard.conf.erb /etc/asgard/

CMD ["/usr/sbin/launch-asgard"]
