#!/bin/bash
sed -i 's/#$ModLoad imudp/$ModLoad imudp/' /etc/rsyslog.conf
sed -i 's/#$UDPServerRun/$UDPServerRun/' /etc/rsyslog.conf
sed -i 's/#$ModLoad imtcp/$ModLoad imtcp/' /etc/rsyslog.conf
sed -i 's/#$InputTCPServerRun/$InputTCPServerRun/' /etc/rsyslog.conf
cat > log_0 <<LOG
if \$syslogfacility-text == 'local6' and \$programname == 'nginx_access' then /var/log/web/nginx/access.log
& ~

if \$syslogfacility-text == 'local6' and \$programname == 'nginx_error' then /var/log/web/nginx/error.log
& ~

\$template RemoteLogs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
& ~
LOG
sed -i ''$(awk '/InputTCPServerRun/ {print NR}' /etc/rsyslog.conf)'r log_0'  /etc/rsyslog.conf
sudo systemctl restart rsyslog
sed -i 's!##tcp_listen_port = 60!tcp_listen_port = 60!' /etc/audit/auditd.conf
service auditd restart
cat >/etc/logrotate.d/web.log <<LOGR
/var/log/audit/*log
{
daily
rotate 3
size 250M
missingok
notifempty
compress
postrotate
  pkill -HUP rsyslog
endscript
}
LOGR
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
  service auditd restart
endscript
}
LOGR
  
