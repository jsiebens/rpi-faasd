#!/bin/bash
set -e

ARCH=$(uname -m)
case $ARCH in
    arm64)
        SUFFIX=arm64
        ;;
    aarch64)
        SUFFIX=arm64
        ;;
    arm*)
        SUFFIX=arm
        ;;
    *)
        echo "Unsupported architecture $ARCH"
        exit 1
esac

CNI_VERSION=v0.8.6

echo "=> Downloading and installing cni plugins"
mkdir -p /opt/cni/bin
curl -sSL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${SUFFIX}-${CNI_VERSION}.tgz | tar -xvz -C /opt/cni/bin