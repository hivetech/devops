FROM centos:7

# setup repositories
RUN rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
# install
RUN yum install -y mesos-0.23.0-1.0.centos701406

EXPOSE 5050

# we need :
#   MESOS_ZK=zk://172.17.0.3:2181/mesos
#   MESOS_QUORUM=1
# optional :
#   MESOS_PORT=5050
#   MESOS_HOSTNAME

CMD ["mesos-master", "--ip=0.0.0.0", "--work_dir=/var/lib/mesos/master", "--log_dir=/var/log/mesos/master"]
