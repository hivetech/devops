# Mesos Deployment Prototype

| container             | status        |
| --------------------- |:-------------:|
| hivetech/mesos.master | [![Docker Repository on Quay.io](https://quay.io/repository/hackliff/mesos.master/status "Docker Repository on Quay.io")](https://quay.io/repository/hackliff/mesos.master) |
| hivetech/marathon     | [![Docker Repository on Quay.io](https://quay.io/repository/hackliff/marathon/status "Docker Repository on Quay.io")](https://quay.io/repository/hackliff/marathon) |
| hivetech/chronos      | [![Docker Repository on Quay.io](https://quay.io/repository/hackliff/chronos/status "Docker Repository on Quay.io")](https://quay.io/repository/hackliff/chronos) |


## Credits

- [Capgemini apollo][1] - _Mesos cluster provisioning and orchestration using Packer and Terraform. An open-source platform for apps, microservices and big data. http://capgemini.github.io/devops/apollo/_
- [Mesoscloud][2] - _Docker images for mesosphere_


## Install (Mac OSX)

Requirements:

- [Docker][4] 1.8 (check [Docker toolbox][3])
- [Digital Ocean][5], with an ssh key associated :

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

# build docker images
./local_bootstrap/bootstrap.sh build

# spin up zookeeper, mesos master, marathon, chronos and mesos slave
./local_bootstrap/bootstrap.sh start
```

__Start jobs with Marathon__

```sh
curl -X POST http://192.168.99.100:8080/v2/apps -H "Content-type: application/json" -d @jobs/marathon.docker.web.json
```

__Start jobs with Chronos__

```sh
curl 192.168.99.100:4400/scheduler/jobs
curl -L -H 'Content-Type: application/json' -X POST -d @jobs/chronos.sample.json 192.168.99.100:4400/scheduler/iso8601
# inside docker
curl -L -H 'Content-Type: application/json' -X POST -d @jobs/chronos.docker.sample.json 192.168.99.100:31362/scheduler/iso8601
```

---

[1]: https://github.com/Capgemini/Apollo
[2]: https://github.com/mesoscloud
[3]: https://www.docker.com/toolbox
[4]: https://www.docker.com/
[5]: https://digitalocean.com
[6]: https://hashicorp.com
