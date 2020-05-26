#!/bin/bash
set -e

echo "=> Downloading and installing inlets oss ${INLETS_OSS_VERSION}"

curl -SLfs "https://github.com/inlets/inlets/releases/download/${INLETS_OSS_VERSION}/inlets-armhf" \
    --output "/usr/local/bin/inlets" \
    && chmod a+x "/usr/local/bin/inlets"

cat - > /etc/systemd/system/inlets.service <<'EOF'
[Unit]
Description=Inlets OSS
After=faasd.service

[Service]
EnvironmentFile=/etc/default/inlets
ExecStart=/usr/local/bin/inlets client --remote ${INLETS_REMOTE} --token ${INLETS_TOKEN} --upstream http://localhost:8080
Type=simple
Restart=always
RestartSec=5
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

systemctl enable inlets