## Домашнее задание  
VPN   
Цель: Студент получил навыки работы с VPN, RAS.   
1.Между двумя виртуалками поднять vpn в режимах  
- tun  
- tap  

2.Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку   

3.\* Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке   

## Решение  
[tap_tcp]: https://github.com/dbudakov/24.VPN/blob/master/images/homework/v1/iperf_tap_tcp.png
[tap_udp]: https://github.com/dbudakov/24.VPN/blob/master/images/homework/v1/iperf_tap_udp.png
[tun_tcp]: https://github.com/dbudakov/24.VPN/blob/master/images/homework/v1/iperf_tun_tcp.png
[tun_udp]: https://github.com/dbudakov/24.VPN/blob/master/images/homework/v1/iperf_tun_udp.png
[tcp]: https://github.com/dbudakov/24.VPN/blob/master/images/homework/v1/tcp.png
[tcp1]: https://github.com/dbudakov/24.VPN/blob/master/images/homework/v1/iperf_tcp.png
[udp]: https://github.com/dbudakov/24.VPN/blob/master/images/homework/v1/udp.png
[udp1]: https://github.com/dbudakov/24.VPN/blob/master/images/homework/v1/iperf_udp.png


### 1.Задание сравнение скорости работы tap и tun. 
Cравнение режимов tap и tun для TCP, слева tap, справа tun   
![tcp]  

Cравнение режимов tap и tun для UDP, слева tap, справа tun    
![udp]    

Режимы работают на разных уронях OSI, `tap` устройство работает на `канальном уровне`(туннель) а `tun` на `сетевом`(маршрутизация).  В результате тестов,  для TCP - скорость передачи(Bandwidth) в `tun` выше чем в режиме `tap`,  и количество повторно переданных пакетов(Retr - segments retransmitted) ниже. Что свидетельствует о лучшем качестве использования `tun` для TCP трафика. В случае с UDP, в `tap` режиме показатель задержки (jitter - latency variation) ниже чем в режиме `tun`, и количество переданных пакет больше. Потери пакетов в двух режимах 0%. Если важна скорость передачи, то можно использовать `tap` режим для UDP, но виртуальный интерфейс будет L2 уровня, то есть весь функционал L3 будет не применим.

### 2. Настройка RAS через openvpn
После деплоя стенда подключение производится из каталога `./roles/templates/pki`, потому-что `ansible`, складывает туда ключи и сертификаты для подключения, подключение производится по команде:  
```
sudo openvpn --config client.conf 
``` 
Проверить подключение можно проверив доступность узла `10.10.10.1`  который является туннельным интерфейсом развёрнутого `server`'a    
### 3. Настройка ocserv
Для проверки потребуется установленный `openconnect` на хостовой машине, после деплоя подключение производится по следующей команде, аккаунт для подключения `test/pass`
```
sudo openconnect -b 192.168.10.10:8090  
## -b будет запускать клиента  фоновом режиме после установления соединения
```
На автонастройку потребуется немного времени, после чего можно проверять доступность `10.10.10.1`  
**_Вaжно:_** _на хостовой машине, поднимется дефолный маршрут через `tun0` и весь трафик будет уходит в туннель, для удаления необходимо выполнить_   
```
sudo ip route del default dev tun0 scope link
```
Чтобы отключиться от туннели введите:
```
sudo pkill openconnect
```
Дополнительно:
http://openmaniak.com/iperf.php  
```
iperf3 - Retr:
  It's the number of TCP segments retransmitted. This can happen if TCP segments are lost in the network due to congestion or corruption.
iperf3 - Jitter:
  - Jitter (latency variation): can be measured with an Iperf UDP test.

```
**_Дополнительная информация по занятию [здесь](https://github.com/dbudakov/24.VPN/blob/master/draft_general)_** 

### Дополнительно:
Различие `tun` и `tap` режимов [здесь](https://en.wikipedia.org/wiki/TUN/TAP) и [здесь](https://community.openvpn.net/openvpn/wiki/BridgingAndRouting)  


