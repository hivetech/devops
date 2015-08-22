#!/usr/bin/env bash

# TODO Support for docker links
# conf (
  BOOT2DOCKER_HOST="192.168.99.100"

  # graylog server
  GRAYLOG_CONF=/etc/graylog/server/server.conf
  PASSWORD=${PASSWORD:-admin}
  GRAYLOG_PASSWORD=$(echo -n ${PASSWORD} | shasum -a 256 | awk '{print $1}')
  GRAYLOG_SERVER_SECRET=${GRAYLOG_SERVER_SECRET:-$(pwgen -s 96)}

  # thrid parties
  ES_HOSTS=${ES_HOSTS:-${BOOT2DOCKER_HOST}}
  ES_NODE_NAME=${ES_NODE_NAME:-graylog}
  # TODO ES_SHARDS
  # TODO replica set, port, user, password
  MONGODB_HOSTS=${MONGODB_HOSTS:-${BOOT2DOCKER_HOST}}
# )

sed -i -e 's/password_secret =.*/password_secret = '${GRAYLOG_SERVER_SECRET}'/' ${GRAYLOG_CONF}
sed -i -e 's/root_password_sha2 =.*/root_password_sha2 = '${GRAYLOG_PASSWORD}'/' ${GRAYLOG_CONF}
sed -i "s/ES_HOSTS/$ES_HOSTS/" ${GRAYLOG_CONF}
sed -i "s/ES_NODE_NAME/$ES_NODE_NAME/" ${GRAYLOG_CONF}
sed -i "s/MONGODB_HOSTS/$MONGODB_HOSTS/" ${GRAYLOG_CONF}

/opt/graylog2-server/bin/graylogctl run
