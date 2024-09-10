DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
RANDOM_STRING := $(shell LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
PATH_INFO=docker-compose-test-$(RANDOM_STRING)

# Image names
.DEFAULT_GOAL := build_ubuntu

# Targets
all: build_fedora build_ubuntu build_debian

build_fedora:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.fedora -t mydockerimage:fedora .
	# Run the fedora container
	@mkdir /tmp/fedora-$(PATH_INFO)-dir
	@chmod 777 /tmp/fedora-$(PATH_INFO)-dir
	@docker run -it -d \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /tmp/fedora-$(PATH_INFO)-dir:/tmp/fedora-$(PATH_INFO)-dir \
		--cidfile /tmp/fedora-$(PATH_INFO) \
		mydockerimage:fedora /bin/bash
	@docker cp $(DIR)/../docker-compose $$(cat /tmp/fedora-$(PATH_INFO)):/tmp/fedora-$(PATH_INFO)-dir
	@docker cp $(DIR)/../install.sh $$(cat /tmp/fedora-$(PATH_INFO)):/tmp/fedora-$(PATH_INFO)-dir
	# Test fedora
	@docker exec -it -w  /tmp/fedora-$(PATH_INFO)-dir $$(cat /tmp/fedora-$(PATH_INFO)) bash install.sh

build_ubuntu:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.ubuntu -t mydockerimage:ubuntu .
	# Run the ubuntu container
	@mkdir /tmp/ubuntu-$(PATH_INFO)-dir
	@chmod 777 /tmp/ubuntu-$(PATH_INFO)-dir
	@docker run -it -d \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /tmp/ubuntu-$(PATH_INFO)-dir:/tmp/ubuntu-$(PATH_INFO)-dir \
		--cidfile /tmp/ubuntu-$(PATH_INFO) \
		mydockerimage:ubuntu /bin/bash
	@docker cp $(DIR)/../docker-compose $$(cat /tmp/ubuntu-$(PATH_INFO)):/tmp/ubuntu-$(PATH_INFO)-dir
	@docker cp $(DIR)/../install.sh $$(cat /tmp/ubuntu-$(PATH_INFO)):/tmp/ubuntu-$(PATH_INFO)-dir
	# Test ubuntu
	@docker exec -it -w /tmp/ubuntu-$(PATH_INFO)-dir $$(cat /tmp/ubuntu-$(PATH_INFO)) bash install.sh

build_debian:
	@DOCKER_CLI_HINTS=false docker build -f Dockerfile.debian -t mydockerimage:debian .
	# Run the debian container
	@mkdir /tmp/debian-$(PATH_INFO)-dir
	@chmod 777 /tmp/debian-$(PATH_INFO)-dir
	@docker run -it -d \
  		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /tmp/debian-$(PATH_INFO)-dir:/tmp/debian-$(PATH_INFO)-dir \
		--cidfile /tmp/debian-$(PATH_INFO) \
		mydockerimage:debian /bin/bash
	@docker cp $(DIR)/../docker-compose $$(cat /tmp/debian-$(PATH_INFO)):/tmp/debian-$(PATH_INFO)-dir
	@docker cp $(DIR)/../install.sh $$(cat /tmp/debian-$(PATH_INFO)):/tmp/debian-$(PATH_INFO)-dir
	# Test debian
	@docker exec -it -w /tmp/debian-$(PATH_INFO)-dir $$(cat /tmp/debian-$(PATH_INFO)) bash install.sh

clean:
	docker rmi mydockerimage:fedora mydockerimage:ubuntu mydockerimage:debian || true

clean_containers:
	@for file in $(wildcard /tmp/*-docker-compose-test-*); do \
		if [ -d "$$file" ]; then continue; fi; \
		echo "Cleaning up container $$(cat $$file)"; \
		docker exec -it -w $$file-dir/docker-compose $$(cat $$file) docker compose down --volumes; \
		docker stop $$(cat $$file) || true; \
		docker rm -f $$(cat $$file) || true; \
		rm -f $$file; \
	done

.PHONY: all build_fedora build_ubuntu build_debian clean clean_containers
