#!/usr/bin/env bash
# encoding: utf-8
# Mesos cluster bootstraper. Copyright (c) 2015, Xavier Bruhiere

# TODO cli : commands, usage, ...
# TODO build images
# TODO fail on bad commands


usage () {
  printf "\nUsage: $0 <command> [<job>]\n"
  printf "\t<command>\tmanage the cluster : build|start|teardown|schedule\n"
  printf "\t<job>\tjob to run with marathon\n"
  printf "\n"
  exit 11
}

rollback() {
  local exit_code=$?
  [[ ${exit_code} -eq 0 ]] || [[ ${exit_code} -eq 11 ]] && exit ${exit_code}
  # TODO swich on exit_code or signal for custom behaviour
  printf "!! something went bad and rollback is not yet implemented (${exit_code}) !!"
}

# init (
  # strict execution
  set -o errexit -o nounset -o pipefail; shopt -s nullglob
  # teardown machines if necessary
  trap rollback INT TERM EXIT

  source "./local_bootstrap/libutils.sh"
  source "./local_bootstrap/libmesos.sh"

  # checking arg and env
  ([[ $# -lt 1 ]] || [[ "$1" = "--help" ]]) && usage
  log "inspecting local environment ..."
  mesos_doctor
# )

# conf (
  # TODO abort on bad output
  VM_IP=$(docker-machine ip dev)
  NAMESPACE="hivetech"
# )

start_cluster () {
  log "initializing cluster ..."
  mesos_init

  # TODO check everythong is ready (call marathon/metrics ?)
  log "cluster ready, starting frameworks ..."
  mesos_upstart
}

build_cluster () {
  local specs_path="./images/containers"
  log "assembling containers ..."
  (cd ${specs_path} && \
    build_component "${NAMESPACE}" "mesos.master" && \
    build_component "${NAMESPACE}" "mesos.slave" && \
    build_component "${NAMESPACE}" "marathon" && \
    build_component "${NAMESPACE}" "chronos" && \
    build_component "${NAMESPACE}" "zookeeper")
}

printf "\n-- Mesos Cluster Bootstraper (idempotent)\n"
printf "   Docker VM ip detected: ${VM_IP}\n\n"

case $1 in

  "start" )
    start_cluster
    ;;

  "build" )
    build_cluster
    ;;

  "teardown" )
    # TODO remove marathon and chronos jobs as well
    remove_component "marathon"
    remove_component "worker-2"
    remove_component "master"
    ;;

  "schedule" )
    job_spec="$2"
    curl -X POST http://${VM_IP}:8080/v2/apps \
      -H "Content-type: application/json" \
      -d @${job_spec}
    ;;

  * )
    fail "unknown command: $1"
    usage
    ;;

esac
