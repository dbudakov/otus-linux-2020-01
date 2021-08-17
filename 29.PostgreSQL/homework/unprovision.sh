#!/bin/bash

sed -i 's!          box.vm.provision "ansible" do |ansible|!#          box.vm.provision "ansible" do |ansible|!' ./Vagrantfile
sed -i 's!            ansible.playbook = "playbooks/pgsql.yml"!#            ansible.playbook = "playbooks/pgsql.yml"!' ./Vagrantfile
sed -i 's!            ansible.become = "true"!#            ansible.become = "true"!' ./Vagrantfile
sed -i 's!          end!#          end!' ./Vagrantfile
