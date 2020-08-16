#!/bin/bash
set -e

DIST=$(echo $1 | cut -f1 -d-)
ARCH=$(echo $1 | cut -f2 -d-)

if [ -z "$2" ]; then
  jq -s '.[0] * .[1]' packer/$DIST/rpi-$1.json packer/$DIST/provisioners.json | sudo -E packer build -parallel-builds=1 -var-file=packer/variables.json -
else
  jq -s '.[0] * .[1]' packer/$DIST/rpi-$1.json packer/$DIST/provisioners.json | sudo -E packer build -parallel-builds=1 -only=$2 -var-file=packer/variables.json -
fi