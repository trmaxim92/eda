#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if ! swapon --show | grep -q .; then
  fallocate -l 2G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=2048
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  grep -q '/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

if ! command -v docker >/dev/null 2>&1; then
  apt-get update -qq
  apt-get install -y -qq ca-certificates curl git
  curl -fsSL https://get.docker.com | sh
  systemctl enable --now docker
fi

mkdir -p /opt/eda
cd /opt/eda

if [ ! -d .git ]; then
  git clone https://github.com/trmaxim92/eda.git .
else
  git fetch origin
  git reset --hard origin/main
fi

echo "VPS ready"
