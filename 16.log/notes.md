```
грог и баггер
logstasch
greylog
syslog-ng

rsyslog + logrotate
  rsyslog
  многопоточность, защита потока, консолидация в БД, фильтр по шаблону, настройка формата лога
  /etc/rsyslog.conf - конфиги
  /etc/rsyslog.d/sftp.conf - модули im(input), om(output), fm(filter), pm(parser), mm(message modification), sm(string generator)
  facility - категории  https://en.wikipedia.org/wiki/Syslog#Facility
  severity - важность https://en.wikipedia.org/wiki/Syslog#Severity_level
systemd-journald
abrtd
auditd
kdump
ELK

/var/log/syslog - системные
/var/log/messages - глобальные
/var/log/atuth.log - авторизация
/var/log/secure - авторизация
/var/log/dmesg - оборудование и драйверу устройств
  dmesg -H # H показывает дату и отсчет времени
  dmesg -l err - уровень дебага error
/var/log/anaconde.log - лог устанки системы
/var/log/audit - лог демона audit(selinux)
/var/log/boot.log - загрузка системы
/var/log/cron

/var/log/yum.log - rpm
/var/log/dpkg.log - debian
/var/log/emerge.log - gentoo

/var/log/mysql
/var/log/apache2
/var/log/nginx

tail -f /var/log/secure - интерактивно
zcat, zgrep, zmore
lnav 




```
