# Mesos Deployment Prototype

| container             | status        |
| --------------------- |:-------------:|
| hivetech/mesos.master | [![Docker Repository on Quay.io](https://quay.io/repository/hackliff/mesos.master/status "Docker Repository on Quay.io")](https://quay.io/repository/hackliff/mesos.master) |
| hivetech/marathon     | [![Docker Repository on Quay.io](https://quay.io/repository/hackliff/marathon/status "Docker Repository on Quay.io")](https://quay.io/repository/hackliff/marathon) |
| hivetech/chronos      | [![Docker Repository on Quay.io](https://quay.io/repository/hackliff/chronos/status "Docker Repository on Quay.io")](https://quay.io/repository/hackliff/chronos) |

## Credits

- [Capgemini apollo][1]
- [Mesoscloud][2]

## Notes

- [Infra conf powered by consul](https://www.terraform.io/intro/examples/consul.html)

## Workflow

- Build docker containers
  - mesos-master
  - marathon
  - chronos
- Build digital ocean images
  - mesos-slave (install docker, mesos slave and service discovery/load balancing)
  - mesos-master (pull mesos, zookeeper, marathon, chronos docker images)

## Install (Mac OSX)

- [Docker][4] 1.8 is required and I advise to use [Docker toolbox][3].
- [Digital Ocean][5] is also required, with an ssh key associated :

```sh
# name it bot_id_rsa
ssh-keygen -t rsa
```

- [Hashicorp tools][6]

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
[5]: https://digitalocean.com
[6]: https://hashicorp.com
