FROM divide/asgard-conjur:base
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

COPY etc-asgard /etc/asgard

COPY scripts /etc/scripts

CMD ["/etc/scripts/launch"]
