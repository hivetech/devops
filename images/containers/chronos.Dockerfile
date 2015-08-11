FROM centos:7

RUN rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
RUN yum install -y \
  mesos-0.23.0-1.0.centos701406 \
  chronos-2.3.4-1.0.81.el7.x86_64 && \
  rm -rf /etc/mesos /etc/chronos/conf

COPY start-chronos.sh /tmp/
EXPOSE 4400

CMD ["/tmp/start-chronos.sh"]
