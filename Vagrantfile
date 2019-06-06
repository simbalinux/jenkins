# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 3000 
    v.cpus   = 1 
  end

  config.vm.define "jenkins" do |pm|
    pm.vm.box = "centos/7"
    # ----- if you would like a static ip and comment out "public_network" 
    #pm.vm.network "private_network", ip: "192.168.35.10"
    pm.vm.network "public_network"
    pm.vm.hostname = "jenkins.local"
    pm.vm.network "forwarded_port", guest: 8080, host: 3444
    pm.vm.network "forwarded_port", guest: 80, host: 80 

    # ----- inline shell jenkins install  && reverse proxy setup using nginx -----
    #pm.vm.provision "shell", path: "./config/strap_jenkins", privileged: false 
    #pm.vm.provision "shell", path: "./config/strap_proxy", privileged: false 

    # ----- copy over the puppet files && puppet apply using "./config/strap_puppet" -----
    pm.vm.provision "file", source: "./puppet", destination: "$HOME/puppet"
    pm.vm.provision "shell", path: "./config/strap_puppet", privileged: false 

    # ----- login to $HOME and cd ./jenkins_jobs and "bash api_commands" to automate jenkins job via shell script   -----
    pm.vm.provision "file", source: "./jenkins_jobs", destination: "$HOME/jenkins_jobs"
  end

 config.vm.define  "awscli" do |host|
    host.vm.box = "ubuntu/xenial64"
    host.vm.hostname = "awscli"
    host.vm.network "public_network"
    # ---- setup aws cli env && direnv for sourcing
    host.vm.provision "shell", path: "./config/strap_aws", privileged: false
    host.vm.provision "shell", path: "./config/direnv-setup", privileged: false
    # ---- copy terraform .tf files ----
    host.vm.provision "file", source: "./terraform_files/main.tf", destination: "$HOME/terransible/"
    host.vm.provision "file", source: "./terraform_files/variables.tf", destination: "$HOME/terransible/"
    host.vm.provision "file", source: "./terraform_files/terraform.tfvars", destination: "$HOME/terransible/"
  end
end
