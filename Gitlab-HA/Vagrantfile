# -*- mode: ruby -*-
# vi: set ft=ruby:
home = ENV['HOME']

MACHINES = {
  :'pg1' => {
      :box_name => "centos/7",
      :ip_addr => '192.168.100.101',
  },
  :'pg2' => {
      :box_name => "centos/7",
      :ip_addr => '192.168.100.102',
  },
  :'node1' => {
    :box_name => "centos/7",
    :ip_addr => '192.168.100.131',
  },
  :'node2' => {
    :box_name => "centos/7",
    :ip_addr => '192.168.100.132',
  },
  :'redis1' => {
    :box_name => "centos/7",
    :ip_addr => '192.168.100.151',
  },
  :'redis2' => {
    :box_name => "centos/7",
    :ip_addr => '192.168.100.152',
  },
  :'git1' => {
    :box_name => "centos/7",
    :ip_addr => '192.168.100.111',
  },
  :'git2' => {
    :box_name => "centos/7",
    :ip_addr => '192.168.100.112',
  },
  :'nginx1' => {
    :box_name => "centos/7",
    :ip_addr => '192.168.100.121',
  },
  :'nginx2' => {
    :box_name => "centos/7",
    :ip_addr => '192.168.100.122',
  }

}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          box.vm.network "private_network", ip:boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            vb.name = boxname.to_s
            case boxname.to_s
            when "node1"
              vb.customize ["modifyvm", :id, "--memory", "256"]
              vb.customize ["modifyvm", :id, "--cpus", "1"]
	      vb.customize ['createhd', '--filename', "~/sata1.vdi" , '--variant', 'Fixed', '--size', "1024"]
              vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
	      vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "~/sata1.vdi"]
            when "node2"
              vb.customize ["modifyvm", :id, "--memory", "256"]
              vb.customize ["modifyvm", :id, "--cpus", "1"]
	      vb.customize ['createhd', '--filename', "./sata2.vdi" , '--variant', 'Fixed', '--size', "1024"]
              vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
	      vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "./sata2.vdi"]
            when "pg1"
              vb.customize ["modifyvm", :id, "--memory", "512"]
              vb.customize ["modifyvm", :id, "--cpus", "1"]
            when "pg2"
              vb.customize ["modifyvm", :id, "--memory", "512"]
              vb.customize ["modifyvm", :id, "--cpus", "1"]
            when "nginx1"
              vb.customize ["modifyvm", :id, "--memory", "256"]
              vb.customize ["modifyvm", :id, "--cpus", "1"]
            when "nginx2"
              vb.customize ["modifyvm", :id, "--memory", "256"]
              vb.customize ["modifyvm", :id, "--cpus", "1"]
            when "redis1"
              vb.customize ["modifyvm", :id, "--memory", "256"]
              vb.customize ["modifyvm", :id, "--cpus", "1"]
            when "redis2"
              vb.customize ["modifyvm", :id, "--memory", "256"]
              vb.customize ["modifyvm", :id, "--cpus", "1"]
            when "git1"
              vb.customize ["modifyvm", :id, "--memory", "4096"]
              vb.customize ["modifyvm", :id, "--cpus", "4"]
            when "git2"
              vb.customize ["modifyvm", :id, "--memory", "4096"]
              vb.customize ["modifyvm", :id, "--cpus", "4"]
        end
      end
          box.vm.provision "ansible" do |ansible|
            #ansible.verbose = "vvv"
            ansible.playbook = "playbooks/pgsql.yml"
            ansible.become = "true"
          end
      end
    end
end
