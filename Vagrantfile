# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", ip: "10.10.10.12"

  config.vm.provider "virtualbox" do |v|
    v.name = "jvm-in-flames"
    v.memory = 2048
    v.cpus = 4
  end

  config.vm.provision "file", source: "vagrant-scripts", destination: "/tmp/vagrant-scripts"
  config.vm.provision "shell", path: "vagrant-scripts/provision.sh"

end
