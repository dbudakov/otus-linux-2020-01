#!/bin/bash

#sh knock.sh host 8881 7777 9991
HOST=$1
shift
for ARG in "$@"
do
        nmap -Pn --host-timeout 100 --max-retries 0 -p $ARG $HOST
done
