FROM uggedal/alpine
MAINTAINER Rafal Rzepecki <rafal@conjur.net>

RUN apk update
RUN apk add ruby nginx-lua ruby-json ruby-bigdecimal
RUN gem install -N conjur-cli

CMD ["/opt/conjur/launch"]

COPY conjur.container.example /etc/
COPY scripts /opt/conjur

