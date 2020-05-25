#!/bin/bash
set -e

curl -sSL https://github.com/caddyserver/caddy/releases/download/v2.0.0/caddy_2.0.0_linux_armv6.tar.gz | tar -xvz -C /usr/local/bin/ caddy

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