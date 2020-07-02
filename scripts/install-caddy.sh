#!/bin/bash
set -e

CADDY_ARCH=armv6

if [[ $PACKER_BUILD_NAME == *"arm64"* ]]; then
  CADDY_ARCH=arm64
fi

echo "=> Downloading and installing Caddy ${CADDY_VERSION} ${CADDY_ARCH}"

curl -sSL "https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_linux_${CADDY_ARCH}.tar.gz" | tar -xvz -C /usr/local/bin/ caddy

cat - > /etc/systemd/system/caddy.service <<'EOF'
[Unit]
Description=Caddy Reverse Proxy
After=faasd.service

[Service]
EnvironmentFile=/etc/default/inlets-pro
ExecStart=/usr/local/bin/caddy reverse-proxy --from ${INLETS_DOMAIN} --to http://127.0.0.1:8080
Type=simple
Restart=always
RestartSec=5
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

systemctl enable caddy