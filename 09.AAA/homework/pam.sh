#!/bin/bash
for i in admin user1 user2;do useradd $i;done
for i in admin user1 user2;do echo "vagrant"|sudo passwd --stdin $i;done
for i in user1 user2;do gpasswd -a $i users;done
sed -i 's!^PasswordAuthentication.*$!PasswordAuthentication yes!' /etc/ssh/sshd_config
systemctl restart sshd.service
cat >> temp_file <<CAT
account    required     pam_time.so
CAT
sed -i ''$(awk '/pam_nologin.so/ {print NR}' /etc/pam.d/sshd)'r temp_file'  /etc/pam.d/sshd
cat >> /root/USERS <<MEMBERS
#!/bin/bash
a=$(awk -F: '/users/ {print $NF}' /etc/group|sed 's/,/|/g') 
sed -i '/rule1/d' /etc/security/time.conf
echo '*;*;'$a';!Wd0000-2400 #rule1' >> /etc/security/time.conf 
MEMBERS
chmod +x /root/USERS && /root/USERS
cat >> /root/CLOSE <<CLOSE
#!/bin/bash
for i in \\$(awk -F: '/users/ {print \\$NF}' /etc/group|sed 's/,/ /g');do pkill -9 -u \\$i;done
CLOSE
chmod +x /root/CLOSE
cat >> /etc/crontab << TASKS
*/10  *  *  *  * root /root/CLOSE
  *  *  *  *  *  root /root/USERS
#*/1  *  *  *  * root echo -e "######   ###   ###### \n  odd minutes \n######   ###   ######"|wall
#*/2  *  *  *  * root echo -e "######   ###   ###### \n  even minutes left \n######   ###   ######"|wall
# 30 17 *  *  fri #время для предупреждения за 30 минут до сброса сессий
# 45 17 *  *  fri #время для предупреждения за 15 минут до сброса сессий
TASKS
systemctl restart crond.service

