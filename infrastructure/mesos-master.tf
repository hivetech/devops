resource "digitalocean_droplet" "mesos-master" {
  image              = "${var.packer_artifact.master}"
  region             = "${var.region}"
  count              = "${var.fleet.masters}"
  name               = "${format("mesos-master-%d", count.index)}"
  size               = "${var.instance_size.master}"
  private_networking = true
  depends_on         = [ "digitalocean_ssh_key.default" ]
  ssh_keys           = [ "${digitalocean_ssh_key.default.id}" ]
}
