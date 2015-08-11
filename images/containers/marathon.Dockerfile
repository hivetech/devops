FROM centos:7

RUN rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
# TODO pin version
RUN yum install -y \
  mesos-0.23.0-1.0.centos701406 \
  marathon-0.9.1-1.0.397.el7.x86_64

# required:
#   export MARATHON_MASTER=zk://172.17.0.3:2181/mesos
#   export MARATHON_ZK=zk://172.17.0.3:2181/marathon
# optional:
#   export MARATHON_HOSTNAME=marathon

EXPOSE 8080

CMD ["marathon"]
