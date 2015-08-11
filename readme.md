# Mesos Deployment Prototype

## Credits

- [Capgemini apollo][1]
- [Mesoscloud][2]

## Deploy

```sh
# build images
cd images/containers
docker buil --rm -t hivetech/mesos-master -f mesos.master.Dockerfile .
docker buil --rm -t hivetech/mesos-slave -f mesos.slave.Dockerfile .
docker buil --rm -t hivetech/zk -f zookeeper.Dockerfile .
docker buil --rm -t hivetech/marathon -f marathon.Dockerfile .
docker buil --rm -t hivetech/chronos -f chronos.Dockerfile .

# start zookeeper
docker run -d \
  --name zk -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper:3.4.6

HOST_IP=$(ipconfig getifaddr en0)
VM_IP=$(docker-machine ip dev)
ZK_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' zk)

# start mesos-master
docker run -d \
  -e MESOS_QUORUM=1 \
  -e MESOS_ZK=zk://$ZK_IP:2181/mesos \
  -e MESOS_HOSTNAME=$VM_IP \
  -p 5050:5050 \
  --name mesos-master --restart always hivetech/mesos-master

# start mesos-slave
# NOTE why binding /sys:/sys ?
docker run -d \
  -e MESOS_MASTER=zk://$ZK_IP:2181/mesos \
  -e MESOS_CONTAINERIZERS=docker,mesos \
  -e MESOS_HOSTNAME=$VM_IP \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name mesos-slave-1 --privileged --restart always hivetech/mesos-slave

# start marathon
docker run -d \
  -e MARATHON_MASTER=zk://$ZK_IP:2181/mesos \
  -e MARATHON_ZK=zk://$ZK_IP:2181/marathon \
  -e MARATHON_TASK_LAUNCH_TIMEOUT=300000 \
  -e MARATHON_HOSTNAME=$VM_IP \
  -e LIBPROCESS_PORT=9090 \
  -p 8080:8080 -p 9090:9090 \
  --name marathon --restart always hivetech/marathon

docker run -d \
  -e CHRONOS_HTTP_PORT=4400 \
  -e CHRONOS_MASTER=zk://$ZK_IP:2181/mesos \
  -e CHRONOS_ZK_HOSTS=$ZK_IP:2181 \
  -p 4400:4400 \
  --name chronos hivetech/chronos
```

## Usage

__Chronos__

```sh
curl 192.168.99.100:4400/scheduler/jobs
curl -L -H 'Content-Type: application/json' -X POST -d @examples/chronos.sample.json 192.168.99.100:4400/scheduler/iso8601
```

__Marathon__

```sh
curl -X POST http://192.168.99.100:8080/v2/apps -d @examples/marathon.docker.web.json -H "Content-type: application/json"
```

```python
# docker run -it --rm -v $(pwd):/app -w /app python:2.7 bash
# pip install httpie==0.9.2 marathon==0.7.1 ipython==3.2.1
import marathon
c = marathon.MarathonClient('http://192.168.99.100:8080')
print('ping - {}'.format(c.ping()))
```

---

[1]: https://github.com/Capgemini/Apollo
[2]: https://github.com/mesoscloud
