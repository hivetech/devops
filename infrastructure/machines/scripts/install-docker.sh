#!/usr/bin/env bash
set -eux
set -o pipefail

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

chkconfig docker on
#service docker start
