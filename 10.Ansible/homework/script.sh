#!/bin/bash

for i in prod-nginx-01 prod-nginx-02
  do
    a=$(vagrant ssh-config $i|awk '/Port/ {print $2}')
    sed -i 's/port_'$i'/'$a'/' ./inventories/production/prod.yml
  done

for i in staging-nginx-01
  do
    a=$(vagrant ssh-config $i|awk '/Port/ {print $2}')
   sed -i 's/port_'$i'/'$a'/' ./inventories/staging/staging.yml
  done
  
ansible -i inventories/production/ prod-nginx-01 -m ping
ansible -i inventories/production/ prod-nginx-02 -m ping
ansible -i inventories/staging/ staging-nginx-01 -m ping

