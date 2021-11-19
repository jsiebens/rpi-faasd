build {
  sources = ["source.arm-image.faasd_raspios", "source.arm-image.faasd_ubuntu"]

  provisioner "shell" {
    environment_vars = [
      "FAASD_VERSION=${var.faasd_version}",
      "INLETS_PRO_VERSION=${var.inlets_pro_version}"
    ]
    scripts = [
      "scripts/install-dependencies.sh",
      "scripts/install-containerd.sh",
      "scripts/install-cni-plugins.sh",
      "scripts/install-faasd.sh",
      "scripts/install-inlets.sh"
    ]
  }
}