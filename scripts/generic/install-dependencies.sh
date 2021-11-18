#!/bin/bash
set -e

apt-get update -y
apt-get install -y \
    runc \
    bridge-utils \
    curl

echo "br_netfilter" | tee -a /etc/modules-load.d/modules.conf
echo "net.bridge.bridge-nf-call-iptables=1" | tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.forwarding=1" | tee -a /etc/sysctl.conf