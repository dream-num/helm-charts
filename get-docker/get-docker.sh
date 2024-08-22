#!/bin/bash

# Determine the directory of the currently running script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to quickly check if a host is reachable (using nc)
host_reachable() {
    # Check if port 443 is open using nc (netcat)
    if command_exists nc; then
        if nc -z -w 2 "$1" 443; then
            return 0 # Host is reachable
        fi
    else
        echo "nc (netcat) not found. Skipping host reachability check."
        return 1
    fi
    return 1 # Host is not reachable
}

join_docker_group() {
    # Ensure the 'docker' group exists
    if ! getent group docker > /dev/null; then
        sudo addgroup --system docker || { echo "Failed to create docker group"; exit 1; }
    fi

    # Add the current user to the 'docker' group
    if ! groups "$USER" | grep &>/dev/null "\bdocker\b"; then
        sudo adduser "$USER" docker || { echo "Failed to add user to docker group"; exit 1; }
    fi

    # Apply group changes immediately
    newgrp docker || { echo "Failed to apply new group settings"; exit 1; }
}

get_docker_officially() {
    # Download the official Docker installation script
    curl -fsSL https://get.docker.com/ -o get-docker.sh || { echo "Failed to download Docker installation script"; exit 1; }

    # Inspect and run the installation script
    less get-docker.sh  # Allow the user to review the script
    sudo sh get-docker.sh || { echo "Failed to install Docker using the official script"; rm -f get-docker.sh; exit 1; }
    join_docker_group

    # Clean up the downloaded script
    rm -f get-docker.sh
}

get_docker_using_snap() {
    # Install Docker using snap
    sudo snap install docker || { echo "Failed to install Docker using snap"; exit 1; }

    # Add the current user to the 'docker' group
    join_docker_group

    # Restart Docker to ensure everything is configured correctly
    sudo snap disable docker && sudo snap enable docker
}

get_docker_unofficially() {
    bash "$SCRIPT_DIR/get-docker-unofficial.sh" || { echo "Failed to install Docker using the unofficial script"; exit 1; }
    join_docker_group
}

# Check if Docker is installed
if ! command_exists docker; then
    echo "Installing Docker..."

    if host_reachable download.docker.com; then
        # Check if download.docker.com is reachable
        echo "download.docker.com is reachable. Installing Docker using the official script..."
        get_docker_officially
    elif host_reachable mirrors.tuna.tsinghua.edu.cn; then
        # Check if mirrors.tuna.tsinghua.edu.cn is reachable
        echo "mirrors.tuna.tsinghua.edu.cn is reachable. Installing Docker using the unofficial script..."
        get_docker_unofficially
    elif command_exists snap; then
        # Check if snap is installed
        echo "snap is installed. Using snap to install Docker..."
        get_docker_using_snap
    else
        echo "Unable to find a suitable method to help you install Docker. Your network seems unable to connect to the internet. "
        echo "If you want to try offline deployment, please refer to https://docs.docker.com/engine/install/binaries/#install-daemon-and-client-binaries-on-linux for more information."
    fi
fi