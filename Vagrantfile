# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# running the bootstrap as non root user for multi system compatibility
#
# Change the ip address to match your environment 
#
Vagrant.configure(2) do |config|
  config.vm.define  "gcp-jumpbox" do |host|
    # -- chose OS type by ucommenting --
    host.vm.box = "ubuntu/xenial64"
    #host.vm.box = "centos/7"
    host.vm.hostname = "gcp-jumpbox"
    host.vm.network "private_network", ip: "192.168.50.100"
    # -- shell provisioner --
    #
    host.vm.provision "shell", path: "./direnv/direnv-setup", privileged: false
    host.vm.provision "shell", path: "./install_gcp/gcp-setup", privileged: false
    host.vm.provision "shell", path: "./install_iac/install_terra", privileged: false
    # -- stage the app.py
    host.vm.provision "file", source: "./flask_app/app.py", destination: "$HOME/terra/"
    # -- query script for collecting vm/instance information 
    host.vm.provision "file", source: "./install_iac/gcloud_query", destination: "$HOME/terra/"
    # -- copy the main.tf for terraform logic of the POC 
    host.vm.provision "file", source: "./install_iac/main.tf", destination: "$HOME/terra/"
  end
end
