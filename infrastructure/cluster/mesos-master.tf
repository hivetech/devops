resource "digitalocean_droplet" "mesos-master" {
  image              = "${var.packer_artifact.master}"
  region             = "${var.region}"
  count              = "${var.fleet.masters}"
  name               = "${format("mesos-master-%d", count.index)}"
  size               = "${var.instance_size.master}"
  private_networking = true
  depends_on         = [
    "digitalocean_ssh_key.default"
  ]
  ssh_keys           = [
    "${digitalocean_ssh_key.default.id}"
  ]

  connection {
    user = "root"
    type = "ssh"
    key_file = "${var.pvt_key_file}"
    timeout = "2m"
  }

  # NOTE waiting for docker provider to support --net host
  provisioner "remote-exec" {
    inline = [
      # start zookeeper
      # TODO version as variable
      "docker run -d --restart always --name zk --net host -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper:3.4.6",

      # start mesos master
      "docker run -d --restart always --name master --net host -e MESOS_QUORUM=${var.fleet.masters} -e MESOS_ZK=zk://${digitalocean_droplet.mesos-master.ipv4_address}:2181/mesos -e MESOS_CLUSTER=avengers -e MESOS_HOSTNAME=${digitalocean_droplet.mesos-master.ipv4_address} -p 5050:5050 quay.io/hackliff/mesos.master:cloud mesos-master --ip=${digitalocean_droplet.mesos-master.ipv4_address} --work_dir=/var/lib/mesos/master"
    ]
  }
}
