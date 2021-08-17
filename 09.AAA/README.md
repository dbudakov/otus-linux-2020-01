## Домашнее задание  
PAM  
Цель: Студент получил навыки работы с PAM.  
1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников  
* дать конкретному пользователю права работать с докером и возможность рестартить докер сервис    

## Решение   
Чистый скрипт [pam.sh](https://github.com/dbudakov/9.AAA/blob/master/homework/pam.sh)  
Готовим стенд, создаем пользователей, назначаем пароль, и добаляем в группы  
```sh
for i in admin user1 user2;do useradd $i;done
for i in admin user1 user2;do echo "vagrant"|sudo passwd --stdin $i;done
for i in user1 user2;do gpasswd -a $i users;done
```
Разрешаем логин по паролю при подключении по `ssh`  
```
sed -i 's!^PasswordAuthentication.*$!PasswordAuthentication yes!' /etc/ssh/sshd_config
systemctl restart sshd.service
```
Создаем временный файл для дальнейшей вставки в `/etc/pam.d/sshd`, со строкой подключения модуля `pam_time.so`    
```sh
cat >> temp_file <<CAT
account    required     pam_time.so
CAT
```
вставляем содержимое файла в `/etc/pam.d/sshd`  
```sh
sed -i ''$(awk '/pam_nologin.so/ {print NR}' /etc/pam.d/sshd)'r temp_file'  /etc/pam.d/sshd
```
Создаём и назначаем исполняемым скрипт, по актуализации пользователей в группе `users`, для подключений
```sh 
cat >> /root/USERS <<MEMBERS
#!/bin/bash
a=$(awk -F: '/users/ {print $NF}' /etc/group|sed 's/,/|/g') 
sed -i '/rule1/d' /etc/security/time.conf
echo '*;*;'$a';!Wd0000-2400 #rule1' >> /etc/security/time.conf 
MEMBERS
chmod +x /root/USERS && /root/USERS
```
пишим скрипт для закрытия сессия, после чего можно запускать его из `cron` в установленное время
```sh
cat >> /root/CLOSE <<CLOSE
#!/bin/bash
for i in \\$(awk -F: '/users/ {print \\$NF}' /etc/group|sed 's/,/ /g');do pkill -9 -u \\$i;done
CLOSE
chmod +x /root/CLOSE
```
добавляем строки для `cron`, здесь ежеминутная актуализация файлика /etc/security/time.conf, на предмет участников группы `users` и завершение сессий группы `users`, каждые 10 минут. 
```sh
cat >> /etc/crontab << TASKS
  *  *  *  *  *  root /root/USERS #актуализации пользователей для подключения
*/10  *  *  *  * root /root/CLOSE #завершение сессий
#*/1  *  *  *  * root echo -e "######   ###   ###### \n  odd minutes \n######   ###   ######"|wall
#*/2  *  *  *  * root echo -e "######   ###   ###### \n  even minutes left \n######   ###   ######"|wall
# 30 17 *  *  fri #время для предупреждения за 30 минут до сброса сессий
# 45 17 *  *  fri #время для предупреждения за 15 минут до сброса сессий
TASKS
```
пeрезагрузка сервиса `cron`  
```sh
systemctl restart crond.service
```
В итоге на стенд можно попасть с хостовой машины по ip:192.168.11.101   
пользователи которым доступна ВМ по будням: `user1` `user2`, pass: `vagrant`  
пользователь без ограничения доступа: `admin`, pass: `vagrant`  
по добавлению пользователся в группу `users` раз в минуту список пользователей с ограничением обновляется  
для модификации времени рекомендуется использовать `date MMDDHHmmYYYY`  


### Дополнительная информация:    
```sh
gpasswd -d [username] [groupname] #удаление пользователя из группы
crontab -e                        #настройка cron
```
Обязательно прописываем время в настройке `/etc/secure/time.conf` справка пункт `1.5` [здесь](https://xubuntu-ru.net/how-to/101-roditelskiy-kontrol-posredstvom-linux-pam.html)    
```
*;*;user1;!Wd0000-2400
```
