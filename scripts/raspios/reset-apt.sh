#!/bin/bash
set -e

if [[ $PACKER_BUILD_NAME == *"raspios"* ]]; then
  rm /etc/apt/sources.list
  mv /etc/apt/sources.list_orig /etc/apt/sources.list
fi