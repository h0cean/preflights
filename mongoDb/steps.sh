#!/bin/bash

set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

# Detect distribution codename (e.g., focal, jammy)
CODENAME=$(lsb_release -sc)

# Supported versions check
SUPPORTED_CODENAMES=("focal" "jammy" "bullseye" "bookworm")
if [[ ! " ${SUPPORTED_CODENAMES[@]} " =~ " ${CODENAME} " ]]; then
  echo "Unsupported or untested codename: $CODENAME"
  echo "Manually verify if MongoDB supports your distribution version."
  exit 1
fi

# Add MongoDB public GPG key using gpg and save to trusted.gpg.d
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb.gpg

# Create the MongoDB source list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu ${CODENAME}/mongodb-org/7.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update system packages
apt-get update

# Install MongoDB
apt-get install -y mongodb-org

# Enable and start MongoDB as a service
systemctl enable mongod
systemctl start mongod

# Print status
echo "MongoDB 7 installed and service started."
systemctl status mongod --no-pager
