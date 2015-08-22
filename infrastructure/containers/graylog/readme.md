# Centralized Docker Container Logging

> Powered by [Graylog]()

## Notes

- Early release, I don't fully understand Graylog just yet
- Speaking of that, sending logs to the host port mapped to Gralog server doesn't work

_Please use the configured REST transport address (http://172.17.0.71:12900) if you want working examples. This connection to http://192.168.99.100:12900 will cause problems with Access-Control-Allow-Origin._

- It would be nice to leverage server API to automatically create an UDP GELF input

```sh
GRAYLOG_HOST=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' graylog_graylog_1)
curl -XPOST ${GRAYLOG_HOST}:12900/system/inputs -d '{"type": "GELF UDP", "title": "docker", "global": true}'
```

## Usage

__Requirements__

- [docker]()
- [docker-compose]()

Mac users also need [boot2docker]()/[docker-machine]() installed, as packaged by [docker Toolbox]().

__Start__

```sh
docker-compose pull
docker-compose build --no-cache
# start elasticsearch, mongodb, graylog-server and graylog-web
docker-compose up -d

# edit environment variables in docker-compose.yml to connect external services
# TODO describe available variables
```

__Configure docker logging__

__Instructions below come from an [official walkthrough](https://www.graylog.org/centralize-your-docker-container-logging-with-graylog-native-integration/).__

Head to `$(docker-machine ip dev):9000` to configure a new input in the `system`dropdown.
Next, create an `GELF UDP` input through the Graylog web interface.

Let's test the installation with this dummy command.

```sh
GRAYLOG_HOST=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' graylog_graylog_1)
docker run --log-driver=gelf --log-opt gelf-address=udp://${GRAYLOG_HOST}:12201 busybox echo Hello Graylog
```
