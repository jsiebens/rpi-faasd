#!/bin/bash
set -e

sudo packer init packer/
sudo packer build -parallel-builds=1 packer/