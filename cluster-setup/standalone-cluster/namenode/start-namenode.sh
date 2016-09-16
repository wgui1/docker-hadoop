#!/bin/bash

set -e

NEWLINE=$'\n'
HELP_DESCRIPTION=$"\nUsage: `basename "$0"` <HOST NAME> [DNS SEARCH DOMAIN] [DNS SERVER HOST]
                   \nExample: `basename "$0"` hadoop-master.cluster.local cluster.local dns.cluster.local
                   \n"

if (($# < 1)); then
  echo -e $HELP_DESCRIPTION
  exit 1
fi

HOSTNAME=$1
DNS_SEARCH=$2
DNS_SERVER=$3

if [ -z ${HOSTNAME} ]; then
    echo "Please provide the host name as the first argument"
    exit 1
else
    DOCKER_HOST_NAME="--hostname $HOSTNAME"
    DOCKER_CONTAINER_NAME="--name $HOSTNAME"
fi

if [ -z ${DNS_SEARCH} ]; then
    DOCKER_DNS_SEARCH=""
else
    DOCKER_DNS_SEARCH="--dns-search=$DNS_SEARCH"
fi

if [ -z ${DNS_SERVER} ]; then
    DOCKER_DNS_SERVER=""
else
    DOCKER_DNS_SERVER="--dns=$DNS_SERVER"
fi

docker run -itd \
--privileged \
$DOCKER_HOST_NAME \
$DOCKER_CONTAINER_NAME \
$DOCKER_DNS_SERVER \
$DOCKER_DNS_SEARCH \
-e HADOOP_NAMENODE_HOST=$HOSTNAME \
-p 2222:2222 \
-p 4040:4040 \
-p 8030:8030 \
-p 8031:8031 \
-p 8032:8032 \
-p 8033:8033 \
-p 8088:8088 \
-p 9000:9000 \
-p 9001:9001 \
-p 50070:50070 \
-p 50090:50090 \
-v /hadoop/data:/data \
-v /hadoop/slaves-config:/config:ro \
-v /hadoop/deployments:/deployments:ro \
segence/hadoop:0.4.0
