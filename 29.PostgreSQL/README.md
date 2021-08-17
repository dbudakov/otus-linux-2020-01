## Домашнее задание

PostgreSQL
Цель: Студент получил навыки работы hot_standby.

- Настроить hot_standby репликацию с использованием слотов
- Настроить правильное резервное копирование

Для сдачи работы присылаем ссылку на репозиторий, в котором должны обязательно быть Vagranfile и плейбук Ansible, конфигурационные файлы postgresql.conf, pg_hba.conf и recovery.conf, а так же конфиг barman, либо скрипт резервного копирования. Команда "vagrant up" должна поднимать машины с настроенной репликацией и резервным копированием. Рекомендуется в README.md файл вложить результаты (текст или скриншоты) проверки работы репликации и резервного копирования.

## Решение

Проверка репликации
на ведущем: ps aux | grep sender
на ведущем: su postgres -c 'psql -c "select \* from pg_stat_replication;"'
на ведомом: ps aux | grep receiver

Создание бэкапа
barman backup pg-db-server

Создание бэкапа для проверки настроено на каждую минуту

```
    /etc/crontab
      * * * * * barman /usr/bin/barman backup pg-db-server
      * * * * * barman /usr/bin/barman cron
```

Вывод списка резервных копий
barman list-backup pg-db-server

Вывод более детальной информации по резервной копии
barman show-backup pg-db-server $(barman list-backup pg-db-server|awk 'NR == 1 {print $2}')

Список попадающих файлов в резервную копию
barman list-files pg-db-server $(barman list-backup pg-db-server|awk 'NR == 1 {print $2}')

В работе в ansible для копирования `pgpool-walrecrunning.so` используется модуль `"copy"`, потому что `pgpool-walrecrunning`.so бинарный файл   
   
```
- name: Copy pgpool-walrecrunning.so
  copy:
    src: ../../roles/templates/all/pgpool-walrecrunning.so
    dest: /usr/lib64/pgsql/pgpool-walrecrunning.so
```
Для хоста `barman` используется связка, для начала создания бэкапов, вторая команда нужна для создания бэкапов, но она не выполняется без первой
```
/usr/bin/barman backup pg-db-server || echo 0
barman switch-xlog --force --archive pg-db-server
```
   
Дополнительно:  
[Многоярусный бэкап PostgreSQL с помощью Barman и синхронного переноса журналов транзакций](https://m.habr.com/ru/company/yamoney/blog/333844/)  
https://www.pgpool.net/docs/latest/en/html/example-cluster.html
### DEBUG 
1. ошибка в строке при выводе `barman check [master]`, директории следующих выводов должны совпадать  
`WAL archive: FAILED (please make sure WAL shipping is setup)`
```
barman@backup $ barman show-server pg | grep incoming_wals_directory
# output1
# > incoming_wals_directory: /var/lib/barman/pg/incoming

postgres@pg $ cat /etc/postgresql/10/main/postgresql.conf | grep archive_command
# output2
# > archive_command = 'rsync -a  %p  barman@staging:/var/lib/barman/pg/incoming/%f'
```

2. ошибка
`PostgreSQL: FAILED`
```
нет подключения к базе, проверить строчку 'conninfo' в barman.conf и $PGHOME/log/*log, а также pg_hba.conf на мастер сервере
```

3. формат записи `.pgpass` не поддерживает имена машин нужно писать IP
```
ip:port:database:user:password
192.168.100.111:5432:*:barman:otus
192.168.100.111:5432:*:streaming_barman:otus
```
