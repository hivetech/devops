variable "key_name" {
  description = "The ssh public key name for using with the cloud provider."
  default = "terraform"
}

variable "key_file" {
  description = "The ssh public key path for using with the cloud provider."
  default = "~/.ssh/id_rsa"
}

variable "do_token" {
  description = "The Digital Ocean token."
  default = ""
}

variable "region" {
  description = "The Digital Ocean region to create resources in."
  default = "lon1"
}

variable "fleet" {
  description = "The number of nodes."
  default = {
    masters = "1"
    slaves  = "1"
  }
}

variable "instance_size" {
  default = {
    master = "512mb"
    slave  = "512mb"
  }
}

variable "packer_artifact" {
  description = "machine images to deploy."
  default = {
    master = "docker"
    slave  = "mesos-slave-centos-7-0-x64-1439628361"
  }
}
