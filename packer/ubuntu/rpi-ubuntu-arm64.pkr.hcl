
packer {
  required_plugins {
    arm-image = {
      version = ">= 0.2.5"
      source  = "github.com/solo-io/arm-image"
    }
  }
}

variable "faasd_version" {
  type    = string
  default = "0.14.3"
}

source "arm-image" "faasd_raspios" {
  image_type               = "raspberrypi"
  iso_checksum             = "sha256:a9dddae5c9938c896da9f7c6e47ce11f178cc141ba81a15f4f25fa786300578a"
  iso_url                  = "https://github.com/jsiebens/rpi-cloud-init/releases/download/latest/rpi-cloud-init.zip"
  output_filename          = "images/raspios/rpi-faasd.img"
}

source "arm-image" "faasd_ubuntu" {
  additional_chroot_mounts = [["bind", "/run/systemd", "/run/systemd"]]
  image_mounts             = ["/boot/firmware", "/"]
  image_type               = "raspberrypi"
  iso_checksum             = "sha256:aadc64a1d069c842e56a4289fe1a6b4b5a0af4efcf95bcce78eb2a80fe5270f4"
  iso_url                  = "http://cdimage.ubuntu.com/releases/20.04.1/release/ubuntu-20.04.1-preinstalled-server-arm64+raspi.img.xz"
  output_filename          = "images/ubuntu/rpi-faasd.img"
  qemu_binary              = "qemu-aarch64-static"
}

build {
  sources = ["source.arm-image.faasd_raspios", "source.arm-image.faasd_ubuntu"]

  provisioner "shell" {
    environment_vars = [
      "FAASD_VERSION=${var.faasd_version}"
    ]
    scripts          = [
      "scripts/generic/install-dependencies.sh", 
      "scripts/generic/install-containerd.sh", 
      "scripts/generic/install-cni-plugins.sh", 
      "scripts/generic/install-faasd.sh"
    ]
  }
}
