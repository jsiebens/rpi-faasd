#!/bin/bash
set -e

install_cni_plugins() {
  cni_version=v0.8.5
  suffix=""
  arch=$(uname -m)
  case $arch in
  x86_64 | amd64)
    suffix=amd64
    ;;
  aarch64)
    suffix=arm64
    ;;
  arm*)
    suffix=arm
    ;;
  *)
    fatal "Unsupported architecture $arch"
    ;;
  esac

  $SUDO mkdir -p /opt/cni/bin
  curl -sSL https://github.com/containernetworking/plugins/releases/download/${cni_version}/cni-plugins-linux-${suffix}-${cni_version}.tgz | $SUDO tar -xvz -C /opt/cni/bin
}

install_cni_plugins
