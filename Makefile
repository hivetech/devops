# Makefile - infrastructure build abstraction
# vim:ft=make

all: containers images

containers:
	./local_bootstrap/dcos.sh build

images:
	packer build images/slave-node-droplet.json

.PHONY: containers images
