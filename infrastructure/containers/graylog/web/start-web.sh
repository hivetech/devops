#!/usr/bin/env bash

# TODO Support for docker links
# conf (
  BOOT2DOCKER_HOST="192.168.99.100"

  GRAYLOG_SERVERS=${GRAYLOG_SERVERSS:-"http://${BOOT2DOCKER_HOST}:12900/"}
  GRAYLOG_SERVER_SECRET=${GRAYLOG_SERVER_SECRET:-$(pwgen -s 96)}
  GRAYLOG_TIMEZONE=${GRAYLOG_TIMEZONE:-"Europe/Paris"}

  GRAYLOG_CONF=/opt/graylog2-web/conf/graylog-web-interface.conf
# )

# "@" espaces "/" in variables
sed -i "s@GRAYLOG_SERVERS@${GRAYLOG_SERVERS}@" ${GRAYLOG_CONF}
sed -i "s/GRAYLOG_SERVER_SECRET/${GRAYLOG_SERVER_SECRET}/"  ${GRAYLOG_CONF}
sed -i "s@GRAYLOG_TIMEZONE@${GRAYLOG_TIMEZONE}@" ${GRAYLOG_CONF}

echo "$(basename $0): Graylog servers:  $GRAYLOG_SERVERS"
echo "$(basename $0): Graylog Timezone: $GRAYLOG_TIMEZONE"
/opt/graylog2-web/bin/graylog-web-interface
