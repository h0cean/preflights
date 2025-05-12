#!/bin/bash

# Create a 2GB swap file
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make swap persistent across reboots
if ! grep -q "^/swapfile" /etc/fstab; then
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# Set swappiness and cache pressure
sudo sysctl -w vm.swappiness=10
sudo sysctl -w vm.vfs_cache_pressure=50

# Make settings persistent
sudo bash -c 'cat <<EOF >> /etc/sysctl.conf

# Custom swap tuning
vm.swappiness=10
vm.vfs_cache_pressure=50
EOF'

echo "Swap setup complete with 2GB swap, swappiness=10, and vfs_cache_pressure=50"
