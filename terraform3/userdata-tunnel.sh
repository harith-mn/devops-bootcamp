#!/bin/bash
set -euo pipefail

# Ensure Docker is installed and running
curl -fsSL https://get.docker.com | sh
systemctl enable --now docker

# Setup ssm-user group permissions
id ssm-user &>/dev/null || useradd -m ssm-user
usermod -aG docker ssm-user

# Run containers with restart policies
docker run -d --name nginx-server --restart unless-stopped -p 80:80 nginx

docker run -d --name cloudflare-tunnel --restart unless-stopped --network host cloudflare/cloudflared:latest \
  tunnel --no-autoupdate run --token ${tunnel_token}