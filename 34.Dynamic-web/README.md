## Домашнее задание

Роль для настройки веб сервера
Варианты стенда
nginx + php-fpm (laravel/wordpress) + python (flask/django) + js(react/angular)
nginx + java (tomcat/jetty/netty) + go + ruby
можно свои комбинации

Реализации на выбор

- на хостовой системе через конфиги в /etc
- деплой через docker-compose

Для усложнения можно попросить проекты у коллег с курсов по разработке

К сдаче примается
vagrant стэнд с проброшенными на локалхост портами
каждый порт на свой сайт
через нжинкс

## Решение

После деплоя стернда по адресу хоста откроется страница с доступными сервисами,
в случае если идёт редирек на `https`, необходимо почистить кэш браузера, проверить работу nginx можно через `curl`

```
http://192.168.100.111
```

Сервисы располагаются на следующих протах

```
Gitlab:    http://192.168.100.111:81
ELK stack: http://192.168.100.111:82
Zabbix:    http://192.168.100.111:83
```
Дополнительно:
```
P.S. Интересное решение с selinux модулями. Ещё варианты:
setsebool nis_enabled on или
https://docs.ansible.com/ansible/latest/modules/seboolean_module.html

yum install -y setools && semanage port -a -t http_port_t -p tcp 81
https://docs.ansible.com/ansible/latest/modules/seport_module.html
```
