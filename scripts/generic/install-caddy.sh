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
        SUFFIX=armv6
        ;;
    *)
        echo "Unsupported architecture $ARCH"
        exit 1
esac

echo "=> Downloading and installing Caddy ${CADDY_VERSION} ${SUFFIX}"

curl -sSL "https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_linux_${SUFFIX}.tar.gz" | tar -xvz -C /usr/local/bin/ caddy

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