FROM java:8
MAINTAINER Xavier Bruhiere <xavier.bruhiere@gmail.com>

ENV GRAYLOG_VERSION 1.1.6

# password generator
RUN apt-get update && apt-get install -y pwgen
# download graylog server
RUN wget -qO /opt/graylog-server-${GRAYLOG_VERSION}.tgz https://packages.graylog2.org/releases/graylog2-server/graylog-${GRAYLOG_VERSION}.tgz && \
  cd /opt && \
  tar xvzf graylog-server-${GRAYLOG_VERSION}.tgz && \
  ln -s graylog-${GRAYLOG_VERSION} graylog2-server && \
  mkdir -p /etc/graylog/server/ && \
  rm *.tgz

ADD ./graylog-server.conf /etc/graylog/server/server.conf
ADD ./start-server.sh /opt/start-server.sh

# Expose ports
#   - 12201: GELF UDP
#   - 12900: REST API
# NOTE 9300 ?
EXPOSE 12201/udp 12900

ENTRYPOINT ["/opt/start-server.sh"]
