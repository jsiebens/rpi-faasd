source "arm-image" "faasd_raspios_armhf" {
  image_type      = "raspberrypi"
  iso_checksum    = "sha256:13d4a46a948293af0f91249882cda46479631734d5b8729d125f7f3376e774f2"
  iso_url         = "https://github.com/jsiebens/rpi-cloud-init/releases/download/v0.5/rpi-cloud-init-raspios-bullseye-armhf.zip"
  output_filename = "images/rpi-faasd-raspios-armhf.img"
}

source "arm-image" "faasd_raspios_arm64" {
  image_type      = "raspberrypi"
  iso_checksum    = "sha256:74a92650b3a6ba01bf5e0e9c3ae9251f61be214de2c0da3957a0738f1ae4274a"
  iso_url         = "https://github.com/jsiebens/rpi-cloud-init/releases/download/v0.5/rpi-cloud-init-raspios-bullseye-arm64.zip"
  output_filename = "images/rpi-faasd-raspios-arm64.img"
  qemu_binary     = "qemu-aarch64-static"
}

source "arm-image" "faasd_ubuntu" {
  additional_chroot_mounts = [["bind", "/run/systemd", "/run/systemd"]]
  image_mounts             = ["/boot/firmware", "/"]
  image_type               = "raspberrypi"
  iso_checksum             = "sha256:aadc64a1d069c842e56a4289fe1a6b4b5a0af4efcf95bcce78eb2a80fe5270f4"
  iso_url                  = "http://cdimage.ubuntu.com/releases/20.04.1/release/ubuntu-20.04.1-preinstalled-server-arm64+raspi.img.xz"
  output_filename          = "images/rpi-faasd-ubuntu-arm64.img"
  qemu_binary              = "qemu-aarch64-static"
}