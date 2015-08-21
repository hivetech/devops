# configuration required :
#   MESOS_ZK=zk://172.17.0.3:2181/mesos
#   MESOS_QUORUM=1
FROM centos:7
MAINTAINER Xavier Bruhiere <xavier.bruhiere@gmail.com>

# setup repositories
RUN rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm && \
  yum install -y mesos-0.23.0-1.0.centos701406

ENV MESOS_WORK_DIR /var/lib/mesos/master
ENV MESOS_LOG_DIR /var/log/mesos/master

EXPOSE 5050

ENTRYPOINT ["mesos-master"]
# NOTE --registry=in_memory ? (cf official image: https://github.com/mesosphere/docker-containers/blob/master/mesos/dockerfile-templates/mesos-master)
# TODO test parameters moved to environment
#CMD ["--work_dir=/var/lib/mesos/master", "--log_dir=/var/log/mesos/master"]
