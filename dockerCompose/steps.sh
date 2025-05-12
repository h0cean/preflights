#!/bin/bash

set -e

echo "[+] Updating package index and installing prerequisites..."
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "[+] Adding Docker GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "[+] Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[+] Updating package index with Docker packages..."
sudo apt update

echo "[+] Installing Docker Engine and Compose plugin..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[+] Checking Docker version..."
docker version

echo "[+] Checking Docker Compose version..."
docker compose version

echo "[+] Adding current user to 'docker' group..."
sudo usermod -aG docker $USER

echo "[*] You may need to log out and back in for group changes to apply."

echo "[✓] Docker and Docker Compose installation complete."
