## Домашнее задание
Vagrant стенд для NFS или SAMBA
Цель: В результате выполнения ДЗ студент получит Vagrant стенд для NFS или SAMBA.
NFS или SAMBA на выбор:

vagrant up должен поднимать 2 виртуалки: сервер и клиент
на сервер должна быть расшарена директория
на клиента она должна автоматически монтироваться при старте (fstab или autofs)
в шаре должна быть папка upload с правами на запись
- требования для NFS: NFSv3 по UDP, включенный firewall

* Настроить аутентификацию через KERBEROS


## Решение  
Был создан каталог `server:/obmen`  и смонтирован в каталог `client:/obmen_1`  

#### Заметки по работе  
После поднятия стенда порты для открытия можно узнать из вывода по команде:    
```
rpcinfo -p|awk '{print $4}'|uniq
```
и открыть их в firewall, т.к. для nfs используется udp, открываем только этот трафик  

```
firewall-cmd \
--add-port=50370/udp \
--add-port=52169/udp \
--add-port=20048/udp \
--add-port=2049/udp \
--add-port=42494/udp \
--add-port=41310/udp \
--permanent
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload
```
Дополнительно:  
http://www.rhd.ru/docs/manuals/enterprise/RHEL-4-Manual/sysadmin-guide/s1-nfs-mount.html  
