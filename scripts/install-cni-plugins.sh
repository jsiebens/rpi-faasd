#!/bin/bash
set -e

CNI_VERSION=v0.8.6

CNI_ARCH=arm

if [[ $PACKER_BUILD_NAME == *"arm64"* ]]; then
  CNI_ARCH=arm64
fi

echo "=> Downloading and installing cni plugins"
mkdir -p /opt/cni/bin
curl -sSL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${CNI_ARCH}-${CNI_VERSION}.tgz | tar -xvz -C /opt/cni/bin