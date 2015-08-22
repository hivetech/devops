#!/usr/bin/env bash
set -eux
set -o pipefail

# TODO tag images
docker pull jplock/zookeeper:${ZK_VERSION}
docker pull quay.io/hackliff/mesos.master:${MESOS_MASTER_VERSION}
docker pull quay.io/hackliff/marathon:${MARATHON_VERSION}
