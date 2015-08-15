#!/usr/bin/env bash
set -eux
set -o pipefail

# The sleep 30 in the example above is very important.
# Because Packer is able to detect and SSH into the instance as soon as SSH is
# available, Ubuntu actually doesn't get proper amounts of time to initialize.
# The sleep makes sure that the OS properly initializes.
sleep 30
yum update -y

rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
yum install -y \
  mesos-${MESOS_VERSION}.centos701406.x86_64 \
  device-mapper-event-libs-1.02.93-3.el7_1.1.x86_64

# NOTE yum only support docker-1.7.1-108.el7.centos.x86_64 (15/08/2015)
# install most recent docker version
cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
yum install -y docker-engine-${DOCKER_VERSION}.el7.centos.x86_64

# point this node at the mesos master
sed -i -e 's/localhost/192.168.33.10/g' /etc/mesos/zk
echo 'docker,mesos' | tee /etc/mesos-slave/containerizers

service mesos-slave start
chkconfig mesos-slave on
chkconfig mesos-master off

chkconfig docker on
service docker start
