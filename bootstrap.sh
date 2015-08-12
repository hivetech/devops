#!/usr/bin/env bash
# encoding: utf-8
# Mesos cluster bootstraper. Copyright (c) 2015, Xavier Bruhiere

# TODO build images

# init
  source "./_utils.sh"
  # TODO abort on bad output
  VM_IP=$(docker-machine ip dev)
#

printf "\n-- Mesos Cluster Bootstraper (idempotent)\n"
printf "   Docker VM ip detected: ${VM_IP}\n\n"

log "inspecting local environment ..."
mesos_doctor

log "running zookeeper ..."
z_id=$(component_run zk -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper:3.4.6)
slog "done with id: ${z_id}"
ZK_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' zk)
slog "zookeeper is ready on ${ZK_IP}\n"

log "running mesos master ..."
mm_id=$(component_run mesos-master \
  -e MESOS_QUORUM=1 \
  -e MESOS_ZK=zk://$ZK_IP:2181/mesos \
  -e MESOS_HOSTNAME=$VM_IP \
  -p 5050:5050 \
  appturbo/mesos-master)
slog "done with id: ${mm_id}"

# TODO loop and start given n workers
log "running mesos slave n1 ..."
# NOTE why binding /sys:/sys ?
ms_id=$(component_run mesos-slave-1 \
  -e MESOS_MASTER=zk://$ZK_IP:2181/mesos \
  -e MESOS_CONTAINERIZERS=docker,mesos \
  -e MESOS_HOSTNAME=$VM_IP \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --privileged appturbo/mesos-slave)
slog "done with id: ${ms_id}"

log "running marathon ..."
ma_id=$(component_run marathon \
  -e MARATHON_MASTER=zk://$ZK_IP:2181/mesos \
  -e MARATHON_ZK=zk://$ZK_IP:2181/marathon \
  -e MARATHON_TASK_LAUNCH_TIMEOUT=300000 \
  -e MARATHON_HOSTNAME=$VM_IP \
  -e LIBPROCESS_PORT=9090 \
  -p 8080:8080 -p 9090:9090 \
  appturbo/marathon)
slog "done with id: ${ma_id}"

log "scheduling mesos-consul framework ..."
curl \
  -X POST \
  -d @images/containers/start-mesos-consul.json \
  -H "Content-Type: application/json" \
  http://192.168.99.100:8080/v2/apps

# TODO start chronos using an http Post job against marathon
#c_id=$(component_run chronos \
  #-e CHRONOS_HTTP_PORT=4400 \
  #-e CHRONOS_MASTER=zk://$ZK_IP:2181/mesos \
  #-e CHRONOS_ZK_HOSTS=$ZK_IP:2181 \
  #-p 4400:4400 \
  #appturbo/chronos)
#slog "done with id: ${c_id}\n"
