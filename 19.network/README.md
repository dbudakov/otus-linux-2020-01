# Домашнее задание
Разворачиваем сетевую лабораторию  
Цель: В результате выполнения ДЗ студент развернет сетевую лабораторию.  
### Дано
https://github.com/erlong15/otus-linux/tree/network
(ветка network)
#### Планируемая архитектура
построить следующую архитектуру

Сеть office1
- 192.168.2.0/26 - dev
- 192.168.2.64/26 - test servers
- 192.168.2.128/26 - managers
- 192.168.2.192/26 - office hardware

Сеть office2
- 192.168.1.0/25 - dev
- 192.168.1.128/26 - test servers
- 192.168.1.192/26 - office hardware


Сеть central
- 192.168.0.0/28 - directors
- 192.168.0.32/28 - office hardware
- 192.168.0.64/26 - wifi

```
Office1 ---\
-----> Central --IRouter --> internet
Office2----/
```
Итого должны получится следующие сервера
- inetRouter
- centralRouter
- office1Router
- office2Router
- centralServer
- office1Server
- office2Server

#### Теоретическая часть
- Найти свободные подсети
- Посчитать сколько узлов в каждой подсети, включая свободные
- Указать broadcast адрес для каждой подсети
- проверить нет ли ошибок при разбиении

#### Практическая часть
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
- при нехватке сетевых интервейсов добавить по несколько адресов на интерфейс

## Решение
Теория:
office1:  
net: 192.168.2.0/26; broadcast: 192.168.2.63; add: 62; min-max: 192.168.2.1-62  
net: 192.168.2.64/26; broadcast: 192.168.2.127; add: 62; min-max: 192.168.2.65-126  
net: 192.168.2.128/26; broadcast: 192.168.2.191; add: 62; min-max: 192.168.2.129-190  
net: 192.168.2.192/26; broadcast: 192.168.2.255; add: 62; min-max: 192.168.2.193-254  
  
office2:  
net: 192.168.1.0/25; broadcast: 192.168.1.127; add: 126; min-max: 192.168.1.1-126  
net: 192.168.1.128/26; broadcast: 192.168.1.191; add: 62; min-max: 192.168.1.129-190  
net: 192.168.1.192/26; broadcast: 192.168.1.255; add: 62; min-max: 192.168.1.193-254  
  
central:  
net: 192.168.0.0/28; broadcast: 192.168.0.15; add:14; min-max: 192.168.0.1-14     
clear  192.168.0.16/28; add: 14    
net: 192.168.0.32/28; broadcast: 192.168.0.47; add: 14; min-max: 192.158.0.33-46      
clear  192.168.0.48/28; add: 14    
net: 192.168.0.64/26; broadcast: 192.168.0.127; add:62; min-max: 192.168.0.65-126      
clear 192.168.0.128/25; add: 126    

### Схема сети  
![](https://github.com/dbudakov/19.network/blob/master/homework/network.jpg)  




#### Дополнительная информация:  
Net-tools (arp, ifconfig, netstat, route) - deprecated  
Iproute2 (ip, ss, tc, nstat)  
NetworkManager (nmcli)  
  
`ip` - управление марúрутизаøией, интерфейсами, arp-таблиøами  
`tc` - traffic control - управлением приоритезаøией трафика  
`ss` - sockstat - информаøиā о socket’ах (одна из сторон netstat)  
`nstat` - информаøиā о сетевýх каунтерах  

Сетевые сниферы   
`tcpdump` - информаøиā о сетевой активности. Работает максималþно близко к “проводу”  
`ngrep` - утилита длā поиска пакетов по содержимому, Network grep. По смýслу схожа с tcpdump.  
`Wireshark (tshark)`
```
tcpdump -ennt eth1 proto 1  

tty1>tcpdump -nnt eth1 proto 6 and port 80 and host myip.ru
tty2>curl -I http://myip.ru/

netstat -n -a - показывает все открытые сокеты с системе
netstat -n -a -t |grep ^tcp|awk '{print $(NF)}'|sort|uniq -c
netstat -n -a -t (n - не резалвить имена, all, t - tcp)
netstat -n -r отобразить маршруты
```
#### Добавить маршруты networking
```
cat>/etc/network/interfaces
up ip ro ad 192.168.5.0/24 via 192.168.1.1 [dev eth1]
```
#### Добавить маршруты nmcli
```
add
nmcli connection modify external ipv4.routes "10.20.30.0/24 192.168.100.10"
nmcli connection modify external +ipv4.routes "10.0.1.0/24 192.168.100.20"
nmcli connection modify external ipv4.routes "10.20.30.0/24 192.168.100.10, 10.0.1.0/24 192.168.100.20"

delete
nmcli connection modify external -ipv4.routes "10.0.1.0/24 192.168.100.20"
nmcli connection modify external ipv4.routes ""
```
```
cat>/etc/sysconfig/network-scripts/route-eth0
10.20.30.0/24 via 192.168.100.10
10.0.1.0/24 via 192.168.10.20
```
