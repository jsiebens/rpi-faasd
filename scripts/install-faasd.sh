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
