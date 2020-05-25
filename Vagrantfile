# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.provision "shell", inline: "sudo apt-get install -y build-essential"
  config.vm.provision "docker", images: ["registry.gitlab.com/nosceon/rpi-images/build-tools:build"]
  
end
