#!/bin/bash

set -e

# Update package lists
apt-get update

# Install required packages
apt-get install -y ansible curl

# Install Ansible roles
ansible-galaxy role install geerlingguy.docker

# Install AWS SSM Session Manager plugin
curl -L "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
  -o /tmp/session-manager-plugin.deb

dpkg -i /tmp/session-manager-plugin.deb

# Install Ansible Prometheus collection
ansible-galaxy collection install prometheus.prometheus

echo "EC2 setup completed successfully."