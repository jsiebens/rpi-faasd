#!/bin/bash
set -e

install_containerd() {
  arch=$(uname -m)
  case $arch in
  x86_64 | amd64)
    curl -sLSf https://github.com/containerd/containerd/releases/download/v1.5.4/containerd-1.5.4-linux-amd64.tar.gz | tar -xvz --strip-components=1 -C /usr/local/bin/
    ;;
  armv7l)
    curl -sSL https://github.com/alexellis/containerd-arm/releases/download/v1.5.4/containerd-1.5.4-linux-armhf.tar.gz | tar -xvz --strip-components=1 -C /usr/local/bin/
    ;;
  aarch64)
    curl -sSL https://github.com/alexellis/containerd-arm/releases/download/v1.5.4/containerd-1.5.4-linux-arm64.tar.gz | tar -xvz --strip-components=1 -C /usr/local/bin/
    ;;
  *)
    fatal "Unsupported architecture $arch"
    ;;
  esac

  systemctl unmask containerd || :
  curl -SLfs https://raw.githubusercontent.com/containerd/containerd/v1.5.4/containerd.service --output /etc/systemd/system/containerd.service
  systemctl enable containerd
}

install_containerd