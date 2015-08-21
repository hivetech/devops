#!/usr/bin/env bash
# encoding: utf-8
# Bash utils. Copyright (c) 2015, Xavier Bruhiere

log () {
  local msg="$1"
  printf "\r\033[00;36m  [ \033[00;34m..\033[00;36m ] $(date +%T) - ${msg}\033[0m\n"
}

# "s" stands for smart_log, but for lazy developers
slog () {
  local r_code="$?"
  [ "${r_code}" -eq "0" ] && success "${@}"
  [ "${r_code}" -eq "0" ] || fail "${@}"
}

success () {
  local msg="$1"
  printf "\r\033[00;36m  [ \033[00;32mOK\033[00;36m ] $(date +%T) - ${1}\033[0m\n"
}

fail () {
  local msg="$1"
  printf "\r\033[00;36m  [\033[00;31mFAIL\033[00;36m] $(date +%T) - ${msg}\033[0m\n\n"
}

# FIXME Kill the session on Mac OSX
die() {
  fail "${@}"
  exit 1
}

is_installed () {
  #dpkg -s "$1" >/dev/null 2>&1
  command -v $1 > /dev/null
  [ "$?" -eq "0" ]
}

require () {
  local program="$1"
  is_installed "docker-machine" && printf "\t✓ found ${program}\n" || die "${program} is required"
}

# TODO generic functions with program array and a for loop
mesos_doctor () {
  require "docker"
  [[ "$(docker ps > /dev/null)" -eq "0" ]] || die "unable to contact docker daemon"
  require "docker-machine"
}

docker_id () {
  local container="$1"
  local cid=$(docker inspect -f '{{ .Id }}' ${container})
  echo ${cid}
}

# TODO remove output: "Error: No such image or container: marathon"
component_run () {
  local container="$1"
  # FIXME it won't run containers that are stopped. Check {{ State.Running }}
  local previous_cid=$(docker_id ${container})
  local cid=$([[ -n "${previous_cid}" ]] || docker run -d --restart always --name ${@})
  echo $(docker_id ${container})
}

component_ip () {
  local container="$1"
  echo "$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container})"
}

build_component () {
  local namespace=$1
  local name=$2
  local tag="${3:-latest}"
  log "building ${namespace}/${name}:${tag} ..."
  docker build --rm -t ${namespace}/${name}:${tag} infrastructure/containers/${name}
}

remove_component () {
  local container=$1
  feedback=$(docker stop --timeout 30 ${container} >/dev/null 2>&1  && docker rm --volumes ${container})
  [[ $? -eq 0 ]] && success "destroyed ${feedback} container ..."
}
