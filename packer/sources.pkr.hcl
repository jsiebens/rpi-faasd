source "arm-image" "faasd_raspios" {
  image_type      = "raspberrypi"
  iso_checksum    = "sha256:411af3f24d036aa28949391fc2a4a7034a69e109fa8004a93322b1254226469d"
  iso_url         = "https://github.com/jsiebens/rpi-cloud-init/releases/download/v0.4/rpi-cloud-init.zip"
  output_filename = "images/rpi-faasd-raspios-armhf.img"
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