#!/bin/bash
chown postgres:postgres /var/log/pgbouncer -R
chown postgres:postgres /var/run/pgbouncer -R
su postgres -c "pkill pgbouncer"
su postgres -c "pgbouncer  -d --verbose /etc/pgbouncer/pgbouncer.ini"
