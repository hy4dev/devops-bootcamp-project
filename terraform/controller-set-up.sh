#!/bin/bash

set -eo pipefail

echo "Starting the tasks..."

# Retry function
retry() {
    local retries=100
    local count=0

    until "$@"; do
        count=$((count + 1))

        if [ "$count" -ge "$retries" ]; then
            echo "ERROR: Command failed after $retries attempts:"
            echo "$*"
            return 1
        fi

        echo "Command failed. Retrying in 15 seconds... ($count/$retries)"
        sleep 15
    done
}

# Wait for network connectivity
echo "Waiting for network connectivity..."

retry curl \
    -fsS \
    --connect-timeout 5 \
    https://www.google.com

echo "Network is ready."

# Update package lists
echo "Updating package lists..."

retry sudo apt-get update

# Install required packages
echo "Installing required packages..."

retry apt-get install -y \
    ansible \
    curl

# Install AWS SSM Session Manager plugin
echo "Installing AWS SSM Session Manager plugin..."

retry curl \
    -fL \
    --connect-timeout 10 \
    --retry 3 \
    "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
    -o /tmp/session-manager-plugin.deb

echo "Installing SSM Session Manager plugin..."

retry sudo dpkg -i /tmp/session-manager-plugin.deb

echo "Tasks are completed successfully."
