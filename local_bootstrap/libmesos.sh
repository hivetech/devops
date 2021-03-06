#!/usr/bin/env bash
# encoding: utf-8
# Bash utils. Copyright (c) 2015, Xavier Bruhiere

mesos_init () {
  # NOTE should I set VM_IP ?

  log "running zookeeper ..."
  local z_id=$(component_run zk \
    -p 2181:2181 -p 2888:2888 -p 3888:3888 \
    jplock/zookeeper:3.4.6)
  slog "done with id: ${z_id}"
  ZK_IP=$(component_ip zk)
  slog "zookeeper is ready on ${ZK_IP}\n"

  log "running mesos master ..."
  local mm_id=$(component_run master \
    -e MESOS_QUORUM=1 \
    -e MESOS_ZK=zk://$ZK_IP:2181/mesos \
    -e MESOS_HOSTNAME=$VM_IP \
    -p 5050:5050 \
    ${NAMESPACE}/mesos.master)
  slog "done with id: ${mm_id}"

  # TODO loop and start given n workers
  log "running mesos slave n1 ..."
  # NOTE why binding /sys:/sys ?
  #-v /sys/fs/cgroup:/sys/fs/cgroup \
  #-p 5051:5051 \
  #-p 31000-31050:31000-31050 \
  local ms_id=$(component_run worker-2 \
    -e MESOS_MASTER=zk://$ZK_IP:2181/mesos \
    -e MESOS_CONTAINERIZERS=docker,mesos \
    -e MESOS_EXECUTOR_REGISTRATION_TIMEOUT=5mins \
    -e MESOS_HOSTNAME=$VM_IP \
    -v /sys:/sys \
    -v /usr/local/bin/docker:/usr/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --privileged ${NAMESPACE}/mesos-slave)
  slog "done with id: ${ms_id}"

  log "running marathon ..."
  local ma_id=$(component_run marathon \
    -e MARATHON_MASTER=zk://$ZK_IP:2181/mesos \
    -e MARATHON_ZK=zk://$ZK_IP:2181/marathon \
    -e MARATHON_TASK_LAUNCH_TIMEOUT=300000 \
    -e MARATHON_HOSTNAME=$VM_IP \
    -p 8080:8080 \
    ${NAMESPACE}/marathon)
  slog "done with id: ${ma_id}"
}

mesos_upstart () {
  : '
  log "scheduling mesos-consul framework ... (waiting 30s for marathon to show up)"
  sleep 30
  curl \
    -X POST \
    -d @jobs/start-mesos-consul.json \
    -H "Content-Type: application/json" \
    http://192.168.99.100:8080/v2/apps
  '

  # TODO more reliable way to wait
  log "scheduling chronos framework ... (waiting 30s for marathon to show up)"
  sleep 30
  # marathon makes this step idempotent as well
  curl \
    -X POST \
    -d @jobs/start-mesos-chronos.json \
    -H "Content-Type: application/json" \
    http://${VM_IP}:8080/v2/apps
  : '
   TODO start chronos using an http Post job against marathon
  local c_id=$(component_run chronos \
    -e CHRONOS_HTTP_PORT=4400 \
    -e CHRONOS_MASTER=zk://$ZK_IP:2181/mesos \
    -e CHRONOS_ZK_HOSTS=$ZK_IP:2181 \
    -p 4400:4400 \
    ${NAMESPACE}/chronos)
    slog "done with id: ${c_id}\n"
  '
}
