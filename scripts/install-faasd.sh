#!/bin/bash
set -e

apt-get install -y \
    runc \
    bridge-utils \
    curl \
    git

mkdir -p /tmp/faasd-installation
cd /tmp/faasd-installation

echo "=> Downloading and installing containerd"

curl -sSL https://github.com/alexellis/containerd-armhf/releases/download/v1.3.2/containerd.tgz | tar -xvz --strip-components=2 -C /usr/local/bin/
curl -SLfs "https://raw.githubusercontent.com/containerd/containerd/v1.3.2/containerd.service" \
    --output "/etc/systemd/system/containerd.service" \
    && chmod 0644 /etc/systemd/system/containerd.service

echo "=> Configuring kernel modules and networking"
echo "br_netfilter" | tee -a /etc/modules-load.d/modules.conf
echo "net.bridge.bridge-nf-call-iptables=1" | tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.forwarding=1" | tee -a /etc/sysctl.conf

echo "=> Downloading and installing cni plugins"
mkdir -p /opt/cni/bin
curl -sSL https://github.com/containernetworking/plugins/releases/download/v0.8.5/cni-plugins-linux-arm-v0.8.5.tgz | tar -xvz -C /opt/cni/bin

echo "=> Downloading and installing faasd ${FAASD_VERSION}"

curl -SLfs "https://github.com/openfaas/faasd/releases/download/${FAASD_VERSION}/faasd-armhf" \
    --output "/usr/local/bin/faasd" \
    && chmod a+x "/usr/local/bin/faasd"

git clone https://github.com/openfaas/faasd

systemctl enable containerd
cd faasd && /usr/local/bin/faasd install

cd /tmp
rm -rf /tmp/faasd-installation

# remove generate basic-auth user and password from pre-built image
rm -rf /var/lib/faasd/secrets/basic-auth-password
rm -rf /var/lib/faasd/secrets/basic-auth-user

echo "=> Installation finished."