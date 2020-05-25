#!/bin/bash
set -e

apt-get install cloud-init -y

sed -i '1 s|$| ds=nocloud;s=file:///boot/|' /boot/cmdline.txt

touch /boot/meta-data
touch /boot/user-data