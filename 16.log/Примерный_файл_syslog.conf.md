Листинг 9.4. Примерный файл /etc/syslog.conf
```
Протоколирование аутентификации. Файл протокола
  auth,authpriv.* /var/log/auth.log
  *.*;auth,authpriv.none -/var/log/syslog
Файл регистрации попыток доступа к системе, имеет  ограниченный доступ. Обычно в этот файл записываются сообщения об удаленном доступе к этой машине, например, сообщения от демона FTP о том, какие пользователи и когда регистрировались на данном сервере.
  authpriv.* /var/log/secure
Сообщения пользовательских программ
  user.* -/var/log/user.log
Протоколировать все информационные сообщения, кроме почтовых
  *.info;mail.none; -/var/log/messages
Протоколирование почты
Уровень отладки, информации и замечаний
  mail. =debug,-mail. =inf o;mail. =notice -/var/log/mail/info
Уровень предупреждений
  mail.=warn -/var/log/mail/warnings
Уровень ошибок
  mail.err -/var/log/mail/errors
Протоколирование демона cron.
  cron.=debug;cron.=info;cron.=notice -/var/log/cron/info
  cron.=warn -/var/log/cron/warnings
  cron.err -/var/log/cron/errors
Протоколирование ядра
  kern.=debug;kern.=infо;kern.=notice -/var/log/kernel/infо
  kern.=warn -/var/log/kernel/warnings
  kern.err -/var/log/kernel/errors

Очередь печати: сообщения уровня от "инфо" до "предупреждений"
  lpr.info;lpr.!err -/var/log/lpr/info
Протоколирование демонов: сообщения всех уровней, кроме "инфо"
  qdaemon.=debug;daemon.l=info -/var/log/daemons
Критические сообщения — всем тревога
  *.emerg *
Сохранять ошибки почты и новостей в отдельном файле
  uucp,news.crit -/var/log/spooler
Загрузочные сообщения
  1оса17.* -/var/log/boot.log
```
