#!/bin/bash
set -e

if [[ $PACKER_BUILD_NAME == *"ubuntu"* ]]; then
  echo "=> Installing containerd"
  apt-get install containerd -y
fi

if [[ $PACKER_BUILD_NAME == *"raspios"* ]]; then
  echo "=> Downloading and installing containerd"
  curl -sSL https://github.com/alexellis/containerd-armhf/releases/download/v1.3.2/containerd.tgz | tar -xvz --strip-components=2 -C /usr/local/bin/
  curl -SLfs "https://raw.githubusercontent.com/containerd/containerd/v1.3.2/containerd.service" \
      --output "/etc/systemd/system/containerd.service" \
      && chmod 0644 /etc/systemd/system/containerd.service
  systemctl enable containerd
fi
