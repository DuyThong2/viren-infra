#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y nginx ufw

systemctl enable nginx
systemctl start nginx

ufw allow OpenSSH || true
ufw allow 80/tcp || true
ufw allow 443/tcp || true
ufw --force enable || true
