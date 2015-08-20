provider "digitalocean" {
  token = "${var.do_token}"
}

/* Create a new SSH key */
resource "digitalocean_ssh_key" "default" {
  name = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}
