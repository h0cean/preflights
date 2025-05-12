#!/bin/bash
set -euo pipefail

# 1. Install prerequisites
apt update -y
apt install -y apt-transport-https gnupg2 ca-certificates lsb-release ubuntu-keyring curl

# 2. Download and verify the NGINX signing key
curl -O https://nginx.org/keys/nginx_signing.key
echo "Verifying key fingerprint..."
gpg --show-keys nginx_signing.key

# Optional: You can verify manually that the fingerprint matches the expected:
# pub   rsa2048 2011-08-19 [SC]
#       573B FD6B 3D8F BC64 107B  B709 7BD9 BF62 3CBB ABEE
# uid           [ unknown] nginx signing key <signing-key@nginx.com>

# 3. Convert and store securely
gpg --dearmor < nginx_signing.key > /usr/share/keyrings/nginx-archive-keyring.gpg
rm nginx_signing.key

# 4. Add NGINX mainline repository
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" \
  > /etc/apt/sources.list.d/nginx.list

# 5. Pin NGINX packages from nginx.org
cat <<EOF > /etc/apt/preferences.d/99nginx
Package: *
Pin: origin nginx.org
Pin: release o=nginx
Pin-Priority: 900
EOF

# 6. Install NGINX
apt update -y
apt install -y nginx

# 7. Optional: systemd override to delay start slightly (if needed)
mkdir -p /etc/systemd/system/nginx.service.d
cat <<EOF > /etc/systemd/system/nginx.service.d/override.conf
[Service]
ExecStartPost=/bin/sleep 0.1
EOF

systemctl daemon-reload

echo "NGINX installation complete."
