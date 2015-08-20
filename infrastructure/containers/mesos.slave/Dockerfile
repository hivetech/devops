FROM centos:7
MAINTAINER Xavier Bruhiere <xavier.bruhiere@gmail.com>

ENV USER root
ENV DOCKER_VERSION 1.6.2

# install
RUN rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
RUN yum install -y mesos-0.23.0-1.0.centos701406 device-mapper-event-libs

# configure docker support
RUN echo 'docker,mesos' > /etc/mesos-slave/containerizers && \
  echo '5mins' > /etc/mesos-slave/executor_registration_timeout
#RUN curl -o /usr/local/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION} && \
#chmod +x /usr/local/bin/docker

EXPOSE 5051

#CMD ["mesos-slave", "--ip=0.0.0.0", "--work_dir=/var/lib/mesos/slave", "--log_dir=/var/log/mesos/slave"]
CMD ["mesos-slave", "--work_dir=/var/lib/mesos/slave", "--log_dir=/var/log/mesos/slave"]
