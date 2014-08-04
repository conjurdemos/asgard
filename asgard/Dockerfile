FROM divide/asgard-conjur:base
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

COPY etc-asgard /etc/asgard

EXPOSE 80

CMD ["/etc/scripts/launch"]

COPY scripts /etc/scripts
COPY etc-nginx /etc/nginx
