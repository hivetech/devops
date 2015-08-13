# Mesos Deployment Prototype

## Credits

- [Capgemini apollo][1]
- [Mesoscloud][2]

## Usage

```sh
./local_bootstrap/bootstrap.sh --help
./local_bootstrap/bootstrap.sh build
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
