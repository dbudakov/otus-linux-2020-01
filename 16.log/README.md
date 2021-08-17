## Домашнее задание    
Настраиваем центральный сервер для сбора логов  
Цель: В результате выполнения ДЗ студент настроит центральный сервер для сбора логов.  
в вагранте поднимаем 2 машины web и log  
на web поднимаем nginx  
на log настраиваем центральный лог сервер на любой системе на выбор  
- journald  
- rsyslog  
- elk  
настраиваем аудит следящий за изменением конфигов нжинкса  
  
все критичные логи с web должны собираться и локально и удаленно  
все логи с nginx должны уходить на удаленный сервер (локально только критичные)  
логи аудита должны также уходить на удаленную систему  
  
\* развернуть еще машину elk  
и таким образом настроить 2 центральных лог системы elk И какую либо еще  
в elk должны уходить только логи нжинкса  
во вторую систему все остальное  
  
## Решение  
![](https://github.com/dbudakov/16.log/blob/master/images/16.log_white.jpg)  
Работа выполнена в виде Vagrantfile'а [см [здесь](https://github.com/dbudakov/16.log/blob/master/homework/Vagrantfile)], который реализует по одному скрипту для настройки каждой из машин.  
### Настройка VM "web"
чистый скрипт лежит здесь [web.sh](https://github.com/dbudakov/16.log/blob/master/homework/web.sh)  
Для начала предустанавливаем nginx
```sh
yum install -y epel-release
yum install -y nginx
```
Записываем во временный файл список правил для настройка rsyslog,  
справку по диррективам можно посмотреть пункты `1.4` и `1.5` [[здесь]](https://github.com/dbudakov/16.log/blob/master/source.md) 
```sh
cat > web_0 <<WEB
#LOCAL
#*.notice       /var/log/LOCAL/notice     #состояние, которое может потребовать внимания
#*.warn         /var/log/LOCAL/warn       #предупреждение
*.err           /var/log/LOCAL/err        #ошибка
*.crit          /var/log/LOCAL/crit       #критическое состояние
*.alert         /var/log/LOCAL/alert      #состояние, требующее немедленного вмешательства

#REMOTE
#*.*
auth.*          @@192.168.11.102:514      #Сообщения, поступающие от сервисов авторизации и безопасности
authpriv.*      @@192.168.11.102:514      #aналог "auth"
cron.*          @@192.168.11.102:514      #сообщения демона Cron
daemon.*        @@192.168.11.102:514      #сообщения от демонов
kern.*          @@192.168.11.102:514      #сообщения ядра Linux
#lpr.*                                    #сообщения, связанные с печатью
#mail.*                                   #сообщения подсистемы почты;
#mark.*                 
#news.*                                   #сообщения подсистемы новостей сети
#security.*                               #аналог "auth"
syslog.*        @@192.168.11.102:514      #системный журнал
user.*          @@192.168.11.102:514      #сообщения пользовательских программ
#uucp.*
local6.*        @@192.168.11.102:514      #зарезервировано для локального использования
local7.*        @@192.168.11.102:514      #зарезервировано для локального использования
WEB
```  
Вставляем содержимое созданого файла в `/etc/rsyslog.conf` и перезапускаем службу
```sh
sed -i ''$(awk '/@@remote-host:514/ {print NR}' /etc/rsyslog.conf)'r web_0'  /etc/rsyslog.conf
systemctl restart rsyslog
```  
Настраиваем централизованный сбор логов nginx 
справка пункт `1.3` [[здесь]](https://github.com/dbudakov/16.log/blob/master/source.md) 
```sh

sed -i 's!/var/log/nginx/access.log!syslog:server=192.168.11.102:514,facility=local6,tag=nginx_access,severity=info!' /etc/nginx/nginx.conf
```  
Для `error.log` используем уже знакомую комбинацию со вставкой из файла, а также добавляем `nginx` в автозагрузку и запускаем его:
```sh
cat > web_1 <<WEB
error_log syslog:server=192.168.11.102:514,facility=local6,tag=nginx_error;
WEB
sed -i ''$(awk '/error_log/ {print NR}' /etc/nginx/nginx.conf)'r web_1'  /etc/nginx/nginx.conf

systemctl enable nginx
systemctl start nginx
```  
Настраиваем аудит файла `/etc/nginx/nginx.conf`
справка по настройке пункты `1.8`, `1.6` и `1.7` [[здесь]](https://github.com/dbudakov/16.log/blob/master/source.md) 
```sh
cat >> /etc/audit/rules.d/audit.rules <<AUDIT
-w /etc/nginx/nginx.conf -p wa
AUDIT
```  
Устанавливаем утилиту `audisp-remote`, входит в пакет `audispd-plugins.x86_64` для отправки логов аудита на удаленную машину
```sh
yum install  -y audispd-plugins.x86_64
```  
Включаем плагин для отправки логов  
```sh
sed -i 's!active = no!active = yes!' /etc/audisp/plugins.d/au-remote.conf
```
Настраиваем удалённый сервер для сбора логов
```sh
sed -i 's!remote_server =!remote_server = 192.168.11.102!' /etc/audisp/audisp-remote.conf
```  
Отключаем локальный сбор логов аудита, перезапускаем сервис  
```sh
sed -i 's!write_logs = yes!write_logs = no!' /etc/audit/auditd.conf
systemctl daemon-reload
service auditd restart
```
### Настройка VM "log"
чистый скрипт лежит здесь [logsh](https://github.com/dbudakov/16.log/blob/master/homework/log.sh)
Подключаем модули для принятия `UDP` и `TCP` пакетов, раскомментируя строки нужных параметров, не изменяя порт  
```sh
sed -i 's/#$ModLoad imudp/$ModLoad imudp/' /etc/rsyslog.conf
sed -i 's/#$UDPServerRun/$UDPServerRun/' /etc/rsyslog.conf
sed -i 's/#$ModLoad imtcp/$ModLoad imtcp/' /etc/rsyslog.conf
sed -i 's/#$InputTCPServerRun/$InputTCPServerRun/' /etc/rsyslog.conf
```  
Создаем вспомогательный файл с правилами, для фильтрации поступающих логов, 
немного о настройке пункты `1.1`, `1.2` и `1.3` [[здесь]](https://github.com/dbudakov/16.log/blob/master/source.md) 
```sh
cat > log_0 <<LOG
if \$syslogfacility-text == 'local6' and \$programname == 'nginx_access' then /var/log/web/nginx/access.log
& ~
if \$syslogfacility-text == 'local6' and \$programname == 'nginx_error' then /var/log/web/nginx/error.log
& ~
\$template RemoteLogs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
& ~
LOG
```
Вставляем список правил из созданного файла в `/etc/rsyslog.conf` и перезагружаем `rsyslog`
```sh
sed -i ''$(awk '/InputTCPServerRun/ {print NR}' /etc/rsyslog.conf)'r log_0'  /etc/rsyslog.conf
sudo systemctl restart rsyslog
```   
Настраиваем аудит на принятие пакетов по `60` порту, на портах отличных от `60` сервис может не подняться, также перезагружаем сервис  
```sh
sed -i 's!##tcp_listen_port = 60!tcp_listen_port = 60!' /etc/audit/auditd.conf
service auditd restart
```  
Пишем правила для ротации логов `nginx`
справку по настройке можно посмотреть  пункты `1.6`, `1.7`  [[здесь]](https://github.com/dbudakov/16.log/blob/master/source.md)
```sh
cat >/etc/logrotate.d/web.log <<LOGR
/var/log/audit/*log
{
daily
rotate 3                #максимальное кол-во ротаций, более старые ротации удаляются
size 250M               #порог для обработки логфайла, логи менее 250М ротироваться не будут
missingok               #не выдавать ошибку при отсутствии лог файла
notifempty              #не обрабатывать пустые файлы
compress                #сжимать файл ротации
postrotate              #запуск скрипта 
  pkill -HUP rsyslog    #обрыв связи с inode логфайлов, для создания нового логфайла, без этого логи будут лететь в туже inode, то есть в файл ротации
endscript               #конец скрипта
}
LOGR
```
Аналогичное правило для ротации `audit.log`  
```sh
cat >/etc/logrotate.d/audit.log <<LOGR
/var/log/audit/*log
{
daily
rotate 3
size 250M
missingok
notifempty
compress
postrotate
  service auditd restart    #перезапуск сервиса для создания нового логфайла
endscript
}
LOGR
```
Дополнительно по ротации стоит проверить запуск, как запускается `logrotate` через `cron`  
```sh
ll /etc/cron.daily/  
```
### В итоге по задачам   
критичные логи с web собираются и локально и удалённо, передача идёт по TCP, на `514` порт  
```sh
@web# ls -l /var/log
@log# ls -l /var/log/web/
```  
логи с nginx уходят на `@log`, по UDP на `514` порт, локально пишутся `error.log`, `journalctl` и те что отдает система  
```sh
@web# ls -l /var/log/nginx/error.log  
@log# ls -l /var/log/nginx/  
```  

аудит файла /etc/nginx/nginx.conf настроен и все логи аудита уходят на `@log`, по  TCP, на `60` порт   
@log ll -l /var/log/audit/audit.log   

Для локализации проблем в ходе работы испльзовались утилиты   
```sh
ss -ulntp                       #просмотр открытых портов
tcpdump -i eth1 port 514 -vv    #прослушка определённого порта
tail -f /way/to/file            #просмотр изменения файла в реальном времени
gunzip file.gz                  #распаковка .gz архива
```  
Дополнительно:  
afick - аудит
incron - аудит
[записи](https://github.com/dbudakov/16.log/blob/master/notes.md)  
