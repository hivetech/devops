FROM java:8
MAINTAINER Xavier Bruhiere <xavier.bruhiere@gmail.com>

# dependencies
RUN apt-get update && apt-get install -y \
  pwgen \
  apt-transport-https

# installation
RUN wget https://packages.graylog2.org/repo/packages/graylog-1.1-repository-debian8_latest.deb
RUN dpkg -i graylog-1.1-repository-debian8_latest.deb && \
  rm graylog-*.deb
#RUN apt-get update && apt-get install --yes graylog-server graylog-web
RUN apt-get update && apt-get install --yes graylog-server

# configuration
