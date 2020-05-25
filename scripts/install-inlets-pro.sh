#!/bin/bash
set -e

echo "=> Downloading and installing inlets pro"

curl -SLfs "https://github.com/inlets/inlets-pro/releases/download/0.6.0/inlets-pro-armhf" \
    --output "/usr/local/bin/inlets-pro" \
    && chmod a+x "/usr/local/bin/inlets-pro"

cat - > /etc/systemd/system/inlets.service <<'EOF'
[Unit]
Description=Inlets PRO
After=caddy.service

[Service]
EnvironmentFile=/etc/default/inlets-pro
ExecStart=/usr/local/bin/inlets-pro client --connect ${INLETS_CONNECT} --token ${INLETS_TOKEN} --license ${INLETS_LICENSE} --tcp-ports 80,443
Type=simple
Restart=always
RestartSec=5
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

systemctl enable inlets