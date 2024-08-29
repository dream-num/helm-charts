
# Image names
.DEFAULT_GOAL := build_ubuntu

# Targets
all: build_fedora build_ubuntu build_debian

build_fedora:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.fedora -t mydockerimage:fedora .
	@docker run -it \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		mydockerimage:fedora docker info | head

build_ubuntu:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.ubuntu -t mydockerimage:ubuntu .
	@docker run -it \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		mydockerimage:ubuntu docker info | head

build_debian:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.debian -t mydockerimage:debian .
	@docker run -it \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		mydockerimage:debian docker info | head

clean:
	docker rmi mydockerimage:fedora mydockerimage:ubuntu mydockerimage:debian || true

.PHONY: all build_fedora build_ubuntu build_debian clean
