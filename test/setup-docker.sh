#!/bin/sh

# Determine architecture and set the appropriate variable
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  ARCH="aarch64"
fi

# Set environment variables
DOWNLOAD_URL="https://download.docker.com"
DOCKER_VERSION=27.1.2

# Download and install Docker
curl -fsSLO $DOWNLOAD_URL/linux/static/stable/$ARCH/docker-${DOCKER_VERSION}.tgz
tar xzvf docker-${DOCKER_VERSION}.tgz --strip 1 -C /usr/local/bin docker/docker
rm docker-${DOCKER_VERSION}.tgz

# Set Docker Compose version and install it, refer to https://docs.docker.com/compose/install/linux/#install-the-plugin-manually
DOCKER_COMPOSE_VERSION=v2.29.1
DOCKER_CONFIG=${DOCKER_CONFIG:-/usr/local/lib/docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-$ARCH -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose