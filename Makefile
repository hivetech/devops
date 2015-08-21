# Makefile - infrastructure build abstraction
# vim:ft=make

all: containers images

containers:
	./local_bootstrap/dcos.sh build

image.mesos.slave:
	package validate infrastructure/machines/slave-node-droplet.json
	packer build infrastructure/machines/slave-node-droplet.json

images: image.mesos.slave
	@echo "done building images !"

cluster:
		cd infrastructure/cluster && terraform apply -var-file terraform.tfvars

.PHONY: containers images
