#!/bin/bash
set -e

INLETS_ARCH=armhf

if [[ $PACKER_BUILD_NAME == *"arm64"* ]]; then
  INLETS_ARCH=arm64
fi

echo "=> Downloading and installing inlets oss ${INLETS_OSS_VERSION} ${INLETS_ARCH}"

curl -SLfs "https://github.com/inlets/inlets/releases/download/${INLETS_OSS_VERSION}/inlets-${INLETS_ARCH}" \
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