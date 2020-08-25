#!/bin/bash
set -e

echo "=> Downloading and installing containerd"
curl -sSL https://github.com/alexellis/containerd-armhf/releases/download/v1.3.5/containerd-1.3.5-linux-armhf.tar.gz | tar -xvz --strip-components=1 -C /usr/local/bin/
curl -SLfs "https://raw.githubusercontent.com/containerd/containerd/v1.3.5/containerd.service" \
    --output "/etc/systemd/system/containerd.service" \
    && chmod 0644 /etc/systemd/system/containerd.service
systemctl enable containerd