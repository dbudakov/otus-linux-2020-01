## Домашнее задание  
Сценарии iptables  
Цель: Студент получил навыки работы с centralServer, inetRouter.  
1) реализовать knocking port  
- centralRouter может попасть на ssh inetrRouter через knock скрипт  
пример в материалах  
2) добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост  
3) запустить nginx на centralServer  
4) пробросить 80й порт на inetRouter2 8080  
5) дефолт в инет оставить через inetRouter   
   
* реализовать проход на 80й порт без маскарадинга    
  
## Решение  
![](https://github.com/dbudakov/20.iptables/blob/master/homework/iptables.jpg)

### 1 Задание 
Выполнено с использованием ansible, стренд поднимается по команде `vagrant up` из каталога `homework`  
После поднятия стенда, `inetRouter` будет доступен для подключения по `ssh`, только после предварительного запуска knock.sh, который лежит на `centralRouter` по пути `/vagrant/knock.sh`, поэтому для проверки `knocking port`, нужно   
подключиться к `centralRouter` и выполнить следующие команды:  
ВНИМАНИЕ: `knock port` настроен на цепочки `DROP` поэтому ответа при подключении по ssh, `без стука`, не будет, необходимо прожимать ^C  
```
vagrant ssh centralRouter
## далее с centralRouter
/bin/bash /vagrant/knock.sh 192.168.255.1 8881 7777 9991
ssh vagrant@192.168.255.1
```
### 2,3,4 Задания 
Можно проверить с локальной машини следующей командой:  
```
curl 192.168.11.11:8080
```
Задания реализованы без использования маскарадинга, с помощью обратного маршрута и цепочек `PREROUTING`:
```
centralRouter: ip route add 192.168.11.0/24 via 192.168.155.1  

inetRouter2: "iptables -A PREROUTING -i eth2 -t nat -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.155.2:80" 
centralRouter: "iptables -A PREROUTING -i eth2 -t nat -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.101.2:80"
```
### 5 Задание
Доступ в интернет осуществляется через inetRouter, для сохранения настроек `iptables` устанавливается утилита `iptables-services`, настройки сохраняются в дефолтный файл `/etc/sysconfig/iptables`, при перезагрузке данный файл будет перечитан
```
iptables-save > /etc/sysconfig/iptables
```

