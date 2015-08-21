#!/usr/bin/env bash
set -eux
set -o pipefail

rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
yum install -y \
  mesos-${MESOS_VERSION}.centos701406.x86_64 \
  device-mapper-event-libs-1.02.93-3.el7_1.1.x86_64

# enable docker tasks
echo 'docker,mesos' | tee /etc/mesos-slave/containerizers

#service mesos-slave start
chkconfig mesos-slave on
chkconfig mesos-master off
