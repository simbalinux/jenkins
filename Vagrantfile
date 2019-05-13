# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 2000 
    v.cpus   = 1 
  end

  config.vm.define "jenkins" do |pm|
    pm.vm.box = "centos/7"
    #pm.vm.network "private_network", ip: "192.168.35.10"
    pm.vm.network "public_network"
    pm.vm.hostname = "jenkins.local"
    pm.vm.network "forwarded_port", guest: 8080, host: 3444
    pm.vm.network "forwarded_port", guest: 80, host: 80 
    pm.vm.provision "shell", path: "./config/strap_jenkins", privileged: false 
    pm.vm.provision "shell", path: "./config/strap_proxy", privileged: false 
  end
end
