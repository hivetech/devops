resource "digitalocean_droplet" "mesos-slave" {
  image              = "${var.packer_artifact.slave}"
  region             = "${var.region}"
  count              = "${var.fleet.slaves}"
  name               = "${format("mesos-slave-%d", count.index)}"
  size               = "${var.instance_size.slave}"
  private_networking = true
  depends_on         = [
    "digitalocean_droplet.mesos-master"
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

  # NOTE use private ip ?
  provisioner "remote-exec" {
    inline = [
      "echo zk://${digitalocean_droplet.mesos-master.0.ipv4_address}:2181/mesos > /etc/mesos/zk",
      "echo ${digitalocean_droplet.mesos-slave.ipv4_address} | tee /etc/mesos-slave/ip",
      "cp /etc/mesos-slave/ip /etc/mesos-slave/hostname",

      # restart mesos-slave
      "service mesos-slave restart"
    ]
  }
}
