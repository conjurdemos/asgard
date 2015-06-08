#!/bin/bash

docker run -v $PWD/asgard/sdf.yml:/sdf.yml sdf-gen global sdf.yml > asgard/gatekeeper/global.conf
docker run -v $PWD/asgard/sdf.yml:/sdf.yml sdf-gen global sdf.yml > asgard/eureka/global.conf
docker run -v $PWD/asgard/sdf.yml:/sdf.yml sdf-gen gatekeeper sdf.yml > asgard/gatekeeper/gate.conf
docker run -v $PWD/asgard/sdf.yml:/sdf.yml sdf-gen forwarder -l host/asgard-01 -k the-api-key sdf.yml > asgard/eureka/forward.conf

docker build -t asgard-service asgard/service
docker build -t asgard-eureka asgard/eureka
docker build -t asgard-gatekeeper asgard/gatekeeper

# $generate global eureka.yml > generated/eureka/global.conf
# $generate gatekeeper eureka.yml > generated/eureka/gate.conf
