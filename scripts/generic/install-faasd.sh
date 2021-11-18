#!/bin/bash
set -e

install_faasd() {
  arch=$(uname -m)
  case $arch in
  x86_64 | amd64)
    suffix=""
    ;;
  aarch64)
    suffix=-arm64
    ;;
  armv7l)
    suffix=-armhf
    ;;
  *)
    echo "Unsupported architecture $arch"
    exit 1
    ;;
  esac

  curl -fSLs "https://github.com/openfaas/faasd/releases/download/${FAASD_VERSION}/faasd${suffix}" --output "/usr/local/bin/faasd"
  chmod a+x "/usr/local/bin/faasd"

  mkdir -p /tmp/faasd-${FAASD_VERSION}-installation/hack
  cd /tmp/faasd-${FAASD_VERSION}-installation
  curl -fSLs "https://raw.githubusercontent.com/openfaas/faasd/${FAASD_VERSION}/docker-compose.yaml" --output "docker-compose.yaml"
  curl -fSLs "https://raw.githubusercontent.com/openfaas/faasd/${FAASD_VERSION}/prometheus.yml" --output "prometheus.yml"
  curl -fSLs "https://raw.githubusercontent.com/openfaas/faasd/${FAASD_VERSION}/resolv.conf" --output "resolv.conf"
  curl -fSLs "https://raw.githubusercontent.com/openfaas/faasd/${FAASD_VERSION}/hack/faasd-provider.service" --output "hack/faasd-provider.service"
  curl -fSLs "https://raw.githubusercontent.com/openfaas/faasd/${FAASD_VERSION}/hack/faasd.service" --output "hack/faasd.service"
  /usr/local/bin/faasd install

  # remove generate basic-auth user and password from pre-built image
  rm -rf /var/lib/faasd/secrets/basic-auth-password
  rm -rf /var/lib/faasd/secrets/basic-auth-user
}

install_faasd


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