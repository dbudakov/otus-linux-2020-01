
### Домашнее задание
OSPF
Цель: Студент получил навыки работы с OSPF.  
  - Поднять три виртуалки  
  - Объединить их разными vlan  
1. Поднять OSPF между машинами на базе Quagga  
2. Изобразить ассиметричный роутинг  
3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным  
  
### Решение
![logo7]

В работе используются loopback адреса, которые совпадают с Router-ID и настроены чезез ospf.
```
R1: 10.0.0.1
R2: 10.0.0.2
R3: 10.0.0.3
```
#### Задание 1
В решение используется Vagrant+Asible, настройка quagga осуществляется с помощью установки софта и копирования конфигурационных файлов с хостовой машины
#### Задание 2
Для настройки асимметричного роутинга изменяем стоимость `eth1` на роутере R1:
```
[root@r1 vagrant]# vtysh vtysh
r1# configure terminal
r1(config)# interface  eth1
r1(config-if)# ip ospf  cost  1000
exit
```
После настройки повышения стоимости метрики на eth1 роутера R1 следующую картину, для анализа будет 
использована утилита `tcpdump`, и запуск ее через команду, которая выводит только проходящие icmp пакеты на конкретном интерфейсе
```
clear && echo "hostname:$(hostname)" && tcpdump -i eth[N] icmp
```
Запускаем 1'ин пинг с R1 на R2, 
```
[root@r1 vagrant]# ping 10.0.0.2 -c 1
```

Из вывода трафика icmp на интерфейсах роутера R1, видно что `ICMP echo request` отправляется с `eth2` в `08:31:29.096045`, несмотря на то что на R2 идет прямой линк с `eth1`, а пакет `ICMP echo reply` приходит на `eth1`, на тот самый прямой линк, в `08:31:29.102351` ![logo1]

Из вывода трафика icmp на интерфейсах роутера R2, видно что `ICMP echo request` приходит на `eth2` от адреса `192.168.103.1`, который является линком R1 на R3, и `ICMP echo reply` выходит с `eth1`, который является прямым линком на R1 ![logo2]

Из вывода трафика icmp на интерфейсах роутера R3 видно что он просто переправляет `ICMP echo request`, с `eth2` на  `eth1`, об этом свидетельствует время обработки пакета, на интерфейсах R3 он появляется в `08:31:29.095908`, и следует на R2 и появляется там в `08:31:29.096199` ![logo3]

#### Задание 3
Для настройки симметричного роутинга, увеличим стоимость интерфеса `eth2` на роутере R1:
```
[root@r1 vagrant]# vtysh vtysh
r1# configure terminal
r1(config)# interface  eth2
r1(config-if)# ip ospf  cost  1000
exit
```
В итоге пинг пойдет по прямому линку и не задействует R3.
```
[root@r1 vagrant]# ping 10.0.0.2 -c 1
```
![logo4] ![logo5] ![logo6]

[logo1]: https://github.com/dbudakov/22.route/blob/master/image/asymmetry_route/R1_asymmetry_route.png
[logo2]: https://github.com/dbudakov/22.route/blob/master/image/asymmetry_route/R2_asymmetry_route.png
[logo3]: https://github.com/dbudakov/22.route/blob/master/image/asymmetry_route/R3_asymmetry_route.png
[logo4]: https://github.com/dbudakov/22.route/blob/master/image/asymmetry_route/R1_symmetry_route.png
[logo5]: https://github.com/dbudakov/22.route/blob/master/image/asymmetry_route/R1_symmetry_route.png
[logo6]: https://github.com/dbudakov/22.route/blob/master/image/asymmetry_route/R1_symmetry_route.png
[logo7]: https://github.com/dbudakov/22.route/blob/master/image/scheme/route.jpg

#### Дополнительно:  
Узнать шлюз для адреса  
```
ip route get 192.168.100.101 
```

Ответы на вопросы лекции [здесь](https://github.com/dbudakov/22.OSPF-route/blob/master/answers.md)  
