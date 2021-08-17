# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |v|
	  v.memory = 512
  end

  config.vm.define "pgmaster" do |pgmaster|
    pgmaster.vm.network "private_network", ip: "192.168.11.20", virtualbox__intnet: false
    pgmaster.vm.hostname = "pgmaster"
  end

  config.vm.define "pgslave" do |pgslave|
    pgslave.vm.network "private_network", ip: "192.168.11.21", virtualbox__intnet: false
    pgslave.vm.hostname = "pgslave"
  end

  config.vm.define "barman" do |barman|
    barman.vm.network "private_network", ip: "192.168.11.22", virtualbox__intnet: false
    barman.vm.hostname = "barman"
  end

  config.vm.provision "ansible" do |ansible|
    #ansible.verbose = "v"
    ansible.playbook = "provisioning/playbook.yml"
    ansible.become = "true"
  end


end
