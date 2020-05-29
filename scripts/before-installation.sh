#!/bin/bash
set -e

cp /etc/apt/sources.list /etc/apt/sources.list_orig

if [ ! -z "$PREFERRED_MIRROR" ]; then
    sed -i "s#http://raspbian.raspberrypi.org/raspbian/#${PREFERRED_MIRROR}#g" /etc/apt/sources.list
fi

apt-get update