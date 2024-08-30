DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
RANDOM_STRING := $(shell head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)

# Image names
.DEFAULT_GOAL := build_ubuntu

# Targets
all: build_fedora build_ubuntu build_debian

build_fedora:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.fedora -t mydockerimage:fedora .
	# Run the fedora container
	@docker run -it -d \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(DIR)/../:/tmp \
		--cidfile /tmp/fedora-test-cid-$(RANDOM_STRING) \
		mydockerimage:fedora /bin/bash
	# Test fedora
	@docker exec -it -w /tmp $$(cat /tmp/fedora-test-cid-$(RANDOM_STRING)) bash install.sh

build_ubuntu:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.ubuntu -t mydockerimage:ubuntu .
	# Run the ubuntu container
	@docker run -it -d \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(DIR)/../:/tmp \
		--cidfile /tmp/ubuntu-test-cid-$(RANDOM_STRING) \
		mydockerimage:ubuntu /bin/bash
	# Test ubuntu
	@docker exec -it -w /tmp $$(cat /tmp/ubuntu-test-cid-$(RANDOM_STRING)) bash install.sh

build_debian:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.debian -t mydockerimage:debian .
	# Run the debian container
	@docker run -it -d \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(DIR)/../:/tmp \
		--cidfile /tmp/debian-test-cid-$(RANDOM_STRING) \
		mydockerimage:debian /bin/bash
	# Test debian
	@docker exec -it -w /tmp $$(cat /tmp/debian-test-cid-$(RANDOM_STRING)) bash install.sh

clean:
	docker rmi mydockerimage:fedora mydockerimage:ubuntu mydockerimage:debian || true

clean_containers:
	@for file in $(wildcard /tmp/*-test-cid-*); do \
		echo "Cleaning up container $$(cat $$file)"; \
		docker exec -it -w /tmp/docker-compose $$(cat $$file) docker compose down --volumes; \
		docker rm -f $$(cat $$file) || true; \
		rm -f $$file; \
	done

.PHONY: all build_fedora build_ubuntu build_debian clean clean_containers
