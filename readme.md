# Mesos Deployment Prototype

## Credits

- [Capgemini apollo][1]
- [Mesoscloud][2]

## Workflow

- Build docker containers
  - mesos-master
  - marathon
  - chronos
- Build digital ocean images
  - mesos-slave (install docker, mesos slave and service discovery/load balancing)
  - mesos-master (pull mesos, zookeeper, marathon, chronos docker images)

## Install (Mac OSX)

[Docker][4] 1.8 is required and I advise to use [Docker toolbox][3].

```sh
# infrastructure management
brew install packer terraform
```


## Usage

```sh
./local_bootstrap/bootstrap.sh --help
./local_bootstrap/bootstrap.sh build  # or make build
./local_bootstrap/bootstrap.sh start
```

__Chronos__

```sh
curl 192.168.99.100:4400/scheduler/jobs
curl -L -H 'Content-Type: application/json' -X POST -d @jobs/chronos.sample.json 192.168.99.100:4400/scheduler/iso8601
# inside docker
curl -L -H 'Content-Type: application/json' -X POST -d @jobs/chronos.docker.sample.json 192.168.99.100:31362/scheduler/iso8601
```

__Marathon__

```sh
curl -X POST http://192.168.99.100:8080/v2/apps -H "Content-type: application/json" -d @jobs/marathon.docker.web.json
```

## Cloud Cluster

__Build images__

```sh
# install packer
brew install packer
```

---

[1]: https://github.com/Capgemini/Apollo
[2]: https://github.com/mesoscloud
[3]: https://www.docker.com/toolbox
[4]: https://www.docker.com/
