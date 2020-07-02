#!/bin/bash
set -e

INLETS_ARCH=armhf

if [[ $PACKER_BUILD_NAME == *"arm64"* ]]; then
  INLETS_ARCH=arm64
fi

echo "=> Downloading and installing inlets pro ${INLETS_PRO_VERSION} ${INLETS_ARCH}"

curl -SLfs "https://github.com/inlets/inlets-pro/releases/download/${INLETS_PRO_VERSION}/inlets-pro-${INLETS_ARCH}" \
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