# 

После окончания работы Vagrantfile, выполнить следующий скрипт
```sh
#/bin/bash

if [[ $# == 0 ]]
then
	for i in name_vm shared_path to_point; do
		echo -n $i:
		read -r $i;
	done;
else
	name_vm=$1
	shared_path=$2
	to_point=/mnt
fi

name_path=$(echo $shared_path|awk -F\/ '{print $NF}')
vboxmanage controlvm "${name_vm}" poweroff; sleep 3;
VBoxManage sharedfolder add $name_vm --name $name_path --hostpath $shared_path --readonly --automount --auto-mount-point=$to_point; sleep 3;
vboxmanage startvm "${name_vm}" --type headless
```
