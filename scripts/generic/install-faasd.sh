#!/bin/bash
set -e

ARCH=$(uname -m)
case $ARCH in
    arm64)
        FAASD_ARCH=arm64
        ;;
    aarch64)
        FAASD_ARCH=arm64
        ;;
    arm*)
        FAASD_ARCH=armhf
        ;;
    *)
        echo "Unsupported architecture $ARCH"
        exit 1
esac

apt-get install -y \
    runc \
    bridge-utils \
    curl \
    git

mkdir -p /tmp/faasd-installation
cd /tmp/faasd-installation

echo "=> Configuring kernel modules and networking"
echo "br_netfilter" | tee -a /etc/modules-load.d/modules.conf
echo "net.bridge.bridge-nf-call-iptables=1" | tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.forwarding=1" | tee -a /etc/sysctl.conf

echo "=> Downloading and installing faasd ${FAASD_VERSION}"

curl -SLfs "https://github.com/openfaas/faasd/releases/download/${FAASD_VERSION}/faasd-${FAASD_ARCH}" \
    --output "/usr/local/bin/faasd" \
    && chmod a+x "/usr/local/bin/faasd"

git clone https://github.com/openfaas/faasd && git -C faasd checkout ${FAASD_VERSION}

cd faasd && /usr/local/bin/faasd install

cd /tmp
rm -rf /tmp/faasd-installation

# remove generate basic-auth user and password from pre-built image
rm -rf /var/lib/faasd/secrets/basic-auth-password
rm -rf /var/lib/faasd/secrets/basic-auth-user

echo "=> Installation finished."