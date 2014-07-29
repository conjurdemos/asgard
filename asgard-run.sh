#!/bin/bash

if ! [ -e /etc/conjur.conf ]; then
  /opt/conjur/configure
  echo Saved Conjur configuration.
fi

export ASGARD_HOME=/var/lib/asgard
mkdir -p $ASGARD_HOME

CNF=`/opt/conjur/bin/conjur env template -c /etc/asgard/asgard.env.yaml /etc/asgard/asgard.conf.erb`
ln -sf $CNF $ASGARD_HOME/Config.groovy
echo Asgard configured. Launching...

java -Xmx1024M -XX:MaxPermSize=128m -jar /opt/asgard/asgard-standalone.jar
