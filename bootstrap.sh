#!/usr/bin/env bash
# encoding: utf-8
# Mesos cluster bootstraper. Copyright (c) 2015, Xavier Bruhiere

printf "\n-- Mesos Cluster Bootstraper\n\n"
source "./_utils.sh"

log "inspecting local environment ..."
mesos_doctor
