# LVM

Расширение LVM
```sh
yum install lvm2

# Создание lvm тома
printf "n\np\n\n\n\nw\n" |fdisk /dev/sdb 
  or
fdisk /dev/sdb 
	>n
	>p
	>3
	>t
	>8e
	>w
partprobe
pvcreate /dev/sdb1
vgcreate vg_root /dev/sdb1
lvcreate -n lv_root -l10%FREE /dev/vg_root
#for mirror
#lvcreate -L 500M -m1 -n mirrorlv vg_root
mkfs.xfs /dev/vg_root/lv_root 
mount /dev/vg_root/lv_root /mnt

# Расширение lvm тома
umount /mnt

#if через удаление и переназначение старого тома
fdisk /dev/sdb 
	>d
	>n
	>p
	>3
	>t
	>8e
	>w
partprobe 

partition=/dev/sdb1
pvresize ${partition}

#else через добавление нового тома
fdisk /dev/sdb 
	>n
	>p
	>3
	>t
	>8e
	>w
partprobe 
	
partition=/dev/sdb2
pvcreate ${partition}



#endif

num_vg=1
vg_root=$(vgdisplay| awk '/VG Name/ {print $3}'|sed -n ${num_vg}p)
vgextend ${vg_root} ${partition}


num_lv=1
size=$(vgdisplay |awk '/Free/ {print $5}')
lv_path=$(lvdisplay| awk '/LV Path/ && NR = 1 {print $3}' | sed -n ${num_lv}p)
lvextend -l +${size} ${lv_path}

# if file system is xfs use xfs_growfs, check fs `blkid`
#resize2fs /dev/vg_root/lv_root 
xfs_growfs ${lv_path} 
df -h
```

начало переноса primary lvm

```sh
yum install lvm2 hfsdump
mount /dev/vg_root/lv_root /mnt
xfsdump -J - /dev/sda1 |xfsrestore -J - /mnt
umount /dev/sda1
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-mkconfig /boot/grub2/grub.cfg /dev/vg_root/lv_root
telinit 6
```

Для запуска  скрипта:

```sh
scriptreplay <time.file> <log.file>  
```

### Дополнительно
LVM snapshots explained [hier](https://www.it610.com/article/2406845.htm)  
BTRFS для самых маленьких [hier](https://habr.com/ru/company/veeam/blog/458250/)    
Файл дескриптор в Linux с примерами [hier](https://habr.com/ru/post/471038/)    
