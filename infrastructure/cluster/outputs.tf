output "master_ips" {
   value = "${join(",", digitalocean_droplet.mesos-master.*.ipv4_address)}"
}

output "slave_ips" {
   value = "${join(",", digitalocean_droplet.mesos-slave.*.ipv4_address)}"
}
