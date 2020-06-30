# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/focal64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.provision "build-env", type: "shell", :path => "ci/provision.sh", privileged: false
  
end
