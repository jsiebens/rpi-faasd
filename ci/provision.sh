sudo apt-get update -qq

# Install required packages
sudo apt-get install -y \
    kpartx \
    qemu-user-static \
    wget \
    curl \
    unzip \
    xz-utils

# Download and install packer
[[ -e /tmp/packer ]] && rm -rf /tmp/packer*
wget https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip \
    -q -O /tmp/packer_1.6.0_linux_amd64.zip
pushd /tmp
unzip -u packer_1.6.0_linux_amd64.zip
sudo cp packer /usr/local/bin
rm -rf /tmp/packer*
popd

pushd /usr/local/bin
sudo wget https://github.com/solo-io/packer-builder-arm-image/releases/download/v0.1.6/packer-builder-arm-image
sudo chmod 755 packer-builder-arm-image
popd