#!/bin/bash

/opt/conjur/configure

CNF=`/opt/conjur/bin/conjur env template -c /etc/asgard/asgard.env.yaml /etc/asgard/asgard.conf.erb`
mv $CNF /etc/asgard/asgard.conf
mkdir -p /root/.asgard
ln -sf /etc/asgard/asgard.conf /root/.asgard/Config.groovy

java -Xmx1024M -XX:MaxPermSize=128m -jar /opt/asgard/asgard-standalone.jar
