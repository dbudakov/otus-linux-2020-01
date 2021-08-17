#!/bin/bash
yum install -y epel-release
yum install -y nginx
cat > web_0 <<WEB
#LOCAL
#*.notice       /var/log/LOCAL/notice
#*.warn         /var/log/LOCAL/warn
*.err           /var/log/LOCAL/err
*.crit          /var/log/LOCAL/crit
*.alert         /var/log/LOCAL/alert

#REMOTE
#*.*
auth.*          @@192.168.11.102:514
authpriv.*      @@192.168.11.102:514
cron.*          @@192.168.11.102:514
daemon.*        @@192.168.11.102:514
kern.*          @@192.168.11.102:514
#lpr.*
#mail.*
#mark.*
#news.*
#security.*
syslog.*        @@192.168.11.102:514
user.*          @@192.168.11.102:514
#uucp.*
local6.*        @@192.168.11.102:514
local7.*        @@192.168.11.102:514

WEB
sed -i ''$(awk '/@@remote-host:514/ {print NR}' /etc/rsyslog.conf)'r web_0'  /etc/rsyslog.conf
systemctl restart rsyslog
sed -i 's!/var/log/nginx/access.log!syslog:server=192.168.11.102:514,facility=local6,tag=nginx_access,severity=info!' /etc/nginx/nginx.conf
cat > web_1 <<WEB
error_log syslog:server=192.168.11.102:514,facility=local6,tag=nginx_error;
WEB
sed -i ''$(awk '/error_log/ {print NR}' /etc/nginx/nginx.conf)'r web_1'  /etc/nginx/nginx.conf
systemctl enable nginx
systemctl start nginx
cat >> /etc/audit/rules.d/audit.rules <<AUDIT

# audit nginx.conf
-w /etc/nginx/nginx.conf -p wa

AUDIT
yum install  -y audispd-plugins.x86_64
sed -i 's!active = no!active = yes!' /etc/audisp/plugins.d/au-remote.conf
sed -i 's!remote_server =!remote_server = 192.168.11.102!' /etc/audisp/audisp-remote.conf
sed -i 's!write_logs = yes!write_logs = no!' /etc/audit/auditd.conf
systemctl daemon-reload
service auditd restart
