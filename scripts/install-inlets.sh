#!/bin/bash
set -e

install_inlets() {
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

  curl -SLfs "https://github.com/inlets/inlets-pro/releases/download/${INLETS_PRO_VERSION}/inlets-pro${suffix}" --output "/usr/local/bin/inlets-pro"
  chmod a+x "/usr/local/bin/inlets-pro"

  cat - > /etc/systemd/system/inlets.service <<'EOF'
[Unit]
Description=Inlets PRO
After=caddy.service

[Service]
EnvironmentFile=/etc/default/inlets-pro
ExecStart=/usr/local/bin/inlets-pro http client --url ${INLETS_URL} --token ${INLETS_TOKEN} --license ${INLETS_LICENSE} --upstream http://localhost:8080
Type=simple
Restart=always
RestartSec=5
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF
}

install_inlets
