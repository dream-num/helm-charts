#!/usr/bin/env bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to quickly check if a host is reachable (using ping and nc)
host_reachable() {
    # Ping the host with a single packet and timeout of 2 seconds
    if ping -c 1 -W 2 "$1" > /dev/null 2>&1; then
        # If ping is successful, check if port 443 is open using nc (netcat)
        if nc -z -w 2 "$1" 443; then
            return 0 # Host is reachable
        fi
    fi
    return 1 # Host is not reachable
}


join_docker_group() {
    # Ensure the 'docker' group exists
    if ! getent group docker > /dev/null; then
        sudo addgroup --system docker
    fi

    # Add the current user to the 'docker' group
    if ! groups $USER | grep &>/dev/null "\bdocker\b"; then
        sudo adduser $USER docker
    fi

    # Apply group changes immediately
    newgrp docker
}


# Check if Docker is installed
if ! command_exists docker; then
    echo "Installing Docker..."

    if host_reachable download.docker.com; then
    # Check if download.docker.com is reachable
        echo "download.docker.com is reachable. Installing Docker using the official script..."
        curl -fsSL https://get.docker.com/ | sh
        join_docker_group
    elif command_exists snap; then
        # Check if snap is installed
        echo "snap is installed, using snap to install.."
        sudo snap install docker

        join_docker_group

        # Restart Docker to ensure everything is configured correctly
        sudo snap disable docker
        sudo snap enable docker
    elif host_reachable mirrors.tuna.tsinghua.edu.cn; then
    # Check if mirrors.tuna.tsinghua.edu.cn is reachable
        echo "mirrors.tuna.tsinghua.edu.cn is reachable. Installing Docker using the unofficial script..."
        bash ./get-docker-unofficial.sh
        join_docker_group
    else
        echo "falling back to offline installation..."
    fi

    echo "Docker has been installed and configured."
else
    echo "Docker is already installed. Skipping installation."
fi

