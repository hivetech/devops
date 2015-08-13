#!/usr/bin/env bash
# encoding: utf-8
# Mesos cluster bootstraper. Copyright (c) 2015, Xavier Bruhiere

# TODO cli : commands, usage, ...
# TODO build images
# TODO fail on bad commands

rollback() {
  echo "exit code: $?"
  printf "!! something went bad and rollback is not yet implemented !!"
}

# init (
  # fail on first error
  set -o errexit
  # fail on unknown variables
  set -o nounset
  #[[ -n "${DEBUG}" ]] && set -o xtrace
  # teardown machines if necessary
  trap rollback INT TERM EXIT

  source "./local_bootstrap/libutils.sh"
  source "./local_bootstrap/libmesos.sh"
  # TODO abort on bad output
  VM_IP=$(docker-machine ip dev)
  NAMESPACE="hivetech"
# )

printf "\n-- Mesos Cluster Bootstraper (idempotent)\n"
printf "   Docker VM ip detected: ${VM_IP}\n\n"

start_cluster () {
  log "inspecting local environment ..."
  mesos_doctor

  log "all good, initializing cluster ..."
  mesos_init

  # TODO check everythong is ready (call marathon/metrics ?)
  log "cluster ready, starting frameworks ..."
  mesos_upstart
}

build_cluster () {
  local specs_path="./images/containers"
  (cd ${specs_path} && \
    build_component "${NAMESPACE}" "mesos.master" && \
    build_component "${NAMESPACE}" "mesos.slave" && \
    build_component "${NAMESPACE}" "marathon.slave" && \
    build_component "${NAMESPACE}" "chronos.slave" && \
    build_component "${NAMESPACE}" "zookeeper.slave")
}

#start_cluster
