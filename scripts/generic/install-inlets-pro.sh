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
        SUFFIX=armhf
        ;;
    *)
        echo "Unsupported architecture $ARCH"
        exit 1
esac

echo "=> Downloading and installing inlets pro ${INLETS_PRO_VERSION} ${SUFFIX}"

curl -SLfs "https://github.com/inlets/inlets-pro/releases/download/${INLETS_PRO_VERSION}/inlets-pro-${SUFFIX}" \
    --output "/usr/local/bin/inlets-pro" \
    && chmod a+x "/usr/local/bin/inlets-pro"

cat - > /etc/systemd/system/inlets.service <<'EOF'
[Unit]
Description=Inlets PRO
After=caddy.service

[Service]
EnvironmentFile=/etc/default/inlets-pro
ExecStart=/usr/local/bin/inlets-pro client --url ${INLETS_CONNECT} --token ${INLETS_TOKEN} --license ${INLETS_LICENSE} --ports 80,443
Type=simple
Restart=always
RestartSec=5
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

systemctl enable inlets