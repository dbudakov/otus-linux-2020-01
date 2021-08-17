Разворачивет Zabbix в Vagrant по адресу 192.168.100.102, стенд поднимается из директории `./homework` по команде `vagrant up`, после поднятия на ВМ необходимо выполнить следующие команды:

```
sudo -u postgres createuser --pwprompt zabbix # запросит ввод пароля, для стенда устанавливался '12345678'
sudo -u postgres createdb -O zabbix zabbix
zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix
```

Еще не нашёл проблему с юнитом, zabbix_server запускается с толкача

```
/usr/sbin/zabbix_server -c /etc/zabbix/zabbix_server.conf
```

Данные для подключения ВЕБ консоли

```
#zabbix_login: Admin/zabbix
#zabbix DBPassword: 12345678
#zabbix DBPort: 5432
```
  
В левом верхнем углу в панеле поиска указан логин выполнившего

![dashboard]  
Виджет для `CPU` имеет следующий вид  
![cpu]
Соответствующий `item` для  `cpu`
![cpu_1]

Виджет для `Memory`  
![memory]
Соответствующий `item` для `memory`
![memory_1]

Виджет для `disk`
![disk]
Соответствующие `items` для `disk`
![disk_1]

Виджет для `network`
![network]
Соответствующие `items` для `network`
![network_1]



[dashboard]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_dashbord.png
[cpu]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_cpu_widget.png
[cpu_1]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_cpu_item.png
[disk]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_disk_widget.png
[disk_1]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_disk_item.png
[memory]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_memory_widget.png
[memory_1]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_memory_item.png
[network]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_eth0_widget.png
[network_1]: https://github.com/dbudakov/18.Monitoring/blob/master/images/zabbix_eht0_item.png
