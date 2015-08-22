FROM java:8
MAINTAINER Xavier Bruhiere <xavier.bruhiere@gmail.com>

ENV GRAYLOG_VERSION 1.1.6

# password generator
RUN apt-get update && apt-get install -y pwgen
# download graylog server
RUN wget -qO /opt/graylog-web-interface-${GRAYLOG_VERSION}.tgz https://packages.graylog2.org/releases/graylog2-web-interface/graylog-web-interface-${GRAYLOG_VERSION}.tgz && \
  cd /opt && \
  tar xvzf graylog-web-interface-${GRAYLOG_VERSION}.tgz && \
  ln -s graylog-web-interface-${GRAYLOG_VERSION} graylog2-web && \
  rm *.tgz

ADD ./graylog-web.conf /opt/graylog2-web/conf/graylog-web-interface.conf
ADD ./start-web.sh /opt/start-web.sh

# Expose web interface
EXPOSE 9000

ENTRYPOINT ["/opt/start-web.sh"]
