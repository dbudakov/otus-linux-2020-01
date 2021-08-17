## Домашнее задание  
Настраиваем split-dns  
Цель: В результате выполнения ДЗ студент настроит split-dns.  
взять стенд https://github.com/erlong15/vagrant-bind  
добавить еще один сервер client2  
завести в зоне dns.lab  
имена  
web1 - смотрит на клиент1  
web2 смотрит на клиент2  
  
завести еще одну зону newdns.lab  
завести в ней запись  
www - смотрит на обоих клиентов  
  
настроить split-dns  
клиент1 - видит обе зоны, но в зоне dns.lab только web1  
  
клиент2 видит только dns.lab  
  
\* настроить все без выключения selinux  
Критерии оценки: 4 - основное задание сделано, но есть вопросы  
5 - сделано основное задание  
6 - выполнено задания со звездочкой  
  
## Решение    
Был ряд действий по изменения, playbook и named.conf. В playbook добавлено правило включения параметра `named_write_master_zones` в `SELinux` для прав записи демона `named`. Также переписамы маршруты для зон из `/etc/named` в `/var/named/zones` и проставлены соотвертствующие изменения контекста каталога `/var/named/zones/`. В начале `playbook` для всех хостов настроена сихнронизация времи, через `ntpdate`. Включена защита от перезаписи на файл `/etc/resol.conf` и собственно для демонстрации SELinux, настройка зон производится с клиентов, через `nsupdate`. Файлы `named.conf` переписаны с использованием `view`.     
Для проверки стенда нужно с каждого клиента проверить вводные. Это резолв для `client1` имен `web1.dns.lab` и `www.newdns.lab`  
```
dig @192.168.50.10 web1.dns.lab
dig @192.168.50.10 www.newdns.lab
```
И резолв `web1.dns.lab` и `web2.dns.lab` от `client2`  
```
dig @192.168.50.10 web1.dns.lab
dig @192.168.50.10 web2.dns.lab
```
остальные имена за исключением `ns01` и `ns02` должны быть недоступны  


#### Дополнительная информация:
DNS сервер BIND (теория) [link](https://m.habr.com/ru/post/137587/)  
аудит файла /etc/resolvconf [auditctl] (https://1cloud.ru/help/security/audit-linux-c-pomoshju-auditd)  
запись resolv.conf debian[rdnssd](https://linux.die.net/man/8/rdnssd)  
синхронизация времени [ntpdate](https://serveradmin.ru/ustanovka-nastroyka-i-sinhronizatsiya-vremeni-v-centos/), [ntpdate_v2](https://serveradmin.ru/ntpdate-pool-ntp-org/)  
[SOA](http://www.bog.pp.ru/work/bind.html)  

для allow-transfer и allow-update обычно используют разные ключи (один для обмена данными между серверами, а другой для разрешения изменять зоны и клинетов, dhcp-севреров и пр.)
А ответ  на вопрос,  здесь: https://kb.isc.org/docs/aa-00296
  
[rndc.conf](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/4/html/reference_guide/s2-bind-rndc-configuration-rndcconf) и [man rndc](https://linux.die.net/man/8/rndc)  
В работе используется автоприветствие текстом:  
```motd - сокращение от message of the day; содержимое этого файла вам показывается при входе в систему. Иногда это удобно. В данной работе он используется чтобы```

Про содержимое `view` [здесь](https://kb.isc.org/docs/aa-00295)   
[Настройка логов Bind9](https://ixnfo.com/bind9-logging.html)    
['/etc/named/named.ddns.lab': already in use: /etc/named.conf:93](https://lists.isc.org/pipermail/bind-users/2016-January/096095.html)   
```REFUSED получается когда запрос в ACL не попадает```   

Ответы на вопросы лекции [здесь](https://github.com/dbudakov/23.DNS/blob/master/answers.md)  


```
;
; Обратный файл данных BIND для 1.31.172.in-addr.arpa
;
$TTL 604800
1.31.172.in-addr.arpa. IN SOA ns1.itproffi.ru. admin.itproffi.ru. (
1 ; серийный номер
3h ; обновление каждые 3 часа
1h ; повторная попытка через час
1w ; срок годности – 1 неделя
1h ) ; хранение кэша отказов 1 час;
1.31.172.in-addr.arpa. IN NS ns1.itproffi.ru.
1.31.172.in-addr.arpa. IN NS ns2.itproffi.ru.
10.1.31.172.in-addr.arpa. IN PTR itproffi.ru.
```

```
A-запись — задает преобразование имени хоста в IP-адрес.
MX-запись — определяет почтовый ретранслятор для доменного имени, т.е. узел, который обработает или передаст дальше почтовые сообщения, предназначенные адресату в указанном домене. При наличии нескольких MX-записей сначала происходит попытка доставить почту на ретранслятор с наименьшим приоритетом.
NS-записи — определяют DNS-серверы, которые являются авторитативными для данной зоны.
CNAME-запись — определяет отображение псевдонима в каноническое имя узла.
SRV-запись — позволяет получить имя для искомой службы, а также протокол, по которому эта служба работает.
TXT-запись — содержит общую текстовую информацию. Эти записи могут использоваться в любых целях, например, для указания месторасположения хоста.
AAAA-запись — задает преобразование имени хоста в IPV6-адрес.
SSHFP-запись — используется для хранения слепка ключей SSH в DNS.
```

