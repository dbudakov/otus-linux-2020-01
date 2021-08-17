Три хоста с говорящими названиями: pgmaster, pgslave, barman
Репликация между pgmaster и pgslave работает. Бэкапирование на barman не работает, застревает на этом моменте:

```
[root@barman .ssh]# barman backup pgmaster
Starting backup using postgres method for server pgmaster in /var/lib/barman/pgmaster/base/20200714T100107
Backup start at LSN: 0/8000060 (000000010000000000000008, 00000060)
Starting backup copy via pg_basebackup for 20200714T100107
```

```
[root@barman .ssh]# barman check pgmaster
Server pgmaster:
        PostgreSQL: OK
        superuser or standard user with backup privileges: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: FAILED (have 0 backups, expected at least 5)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archive_mode: OK
        archive_command: OK
        archiver errors: OK
```

```
[root@barman .ssh]# barman diagnose
{
    "global": {
        "config": {
            "backup_options": "concurrent_backup",
            "barman_home": "/var/lib/barman",
            "barman_user": "barman",
            "compression": "gzip",
            "configuration_files_directory": "/etc/barman.d",
            "errors_list": [],
            "log_file": "/var/log/barman/barman.log",
            "log_level": "INFO",
            "path_prefix": "/usr/pgsql-11/bin",
            "recovery_options": "'get-wal'",
            "streaming_archiver_name": "barman_receive_wal"
        },
        "system_info": {
            "barman_ver": "2.11",
            "kernel_ver": "Linux barman 3.10.0-957.12.2.el7.x86_64 #1 SMP Tue May 14 21:24:32 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux",
            "python_ver": "",
            "release": "RedHat Linux CentOS Linux release 7.8.2003 (Core)",
            "rsync_ver": "rsync  version 3.1.2  protocol version 31",
            "ssh_ver": "",
            "timestamp": "Tue Jul 14 10:03:11 2020"
        }
    },
    "servers": {
        "pgmaster": {
            "backups": {
                "20200714T100107": {
                    "backup_id": "20200714T100107",
                    "backup_label": null,
                    "begin_offset": 96,
                    "begin_time": "Tue Jul 14 10:01:07 2020",
                    "begin_wal": "000000010000000000000008",
                    "begin_xlog": "0/8000060",
                    "config_file": "/var/lib/pgsql/11/data/postgresql.conf",
                    "copy_stats": null,
                    "deduplicated_size": null,
                    "end_offset": null,
                    "end_time": null,
                    "end_wal": null,
                    "end_xlog": null,
                    "error": null,
                    "hba_file": "/var/lib/pgsql/11/data/pg_hba.conf",
                    "ident_file": "/var/lib/pgsql/11/data/pg_ident.conf",
                    "included_files": null,
                    "mode": "postgres",
                    "pgdata": "/var/lib/pgsql/11/data",
                    "server_name": "pgmaster",
                    "size": null,
                    "status": "STARTED",
                    "systemid": "6849144001185053721",
                    "tablespaces": null,
                    "timeline": 1,
                    "version": 110008,
                    "xlog_segment_size": 16777216
                }
            },
            "config": {
                "active": true,
                "archiver": true,
                "archiver_batch_size": 0,
                "backup_directory": "/var/lib/barman/pgmaster",
                "backup_method": "postgres",
                "backup_options": "concurrent_backup",
                "bandwidth_limit": null,
                "barman_home": "/var/lib/barman",
                "barman_lock_directory": "/var/lib/barman",
                "basebackup_retry_sleep": 30,
                "basebackup_retry_times": 0,
                "basebackups_directory": "/var/lib/barman/pgmaster/base",
                "check_timeout": 30,
                "compression": "gzip",
                "conninfo": "host=pgmaster port=5432 user=barman dbname=postgres",
                "create_slot": "manual",
                "custom_compression_filter": null,
                "custom_decompression_filter": null,
                "description": "Master backup",
                "disabled": false,
                "errors_directory": "/var/lib/barman/pgmaster/errors",
                "immediate_checkpoint": false,
                "incoming_wals_directory": "/var/lib/barman/pgmaster/incoming",
                "last_backup_maximum_age": null,
                "max_incoming_wals_queue": null,
                "minimum_redundancy": 5,
                "msg_list": [],
                "name": "pgmaster",
                "network_compression": false,
                "parallel_jobs": 1,
                "path_prefix": "/usr/pgsql-11/bin",
                "post_archive_retry_script": null,
                "post_archive_script": null,
                "post_backup_retry_script": null,
                "post_backup_script": null,
                "post_delete_retry_script": null,
                "post_delete_script": null,
                "post_recovery_retry_script": null,
                "post_recovery_script": null,
                "post_wal_delete_retry_script": null,
                "post_wal_delete_script": null,
                "pre_archive_retry_script": null,
                "pre_archive_script": null,
                "pre_backup_retry_script": null,
                "pre_backup_script": null,
                "pre_delete_retry_script": null,
                "pre_delete_script": null,
                "pre_recovery_retry_script": null,
                "pre_recovery_script": null,
                "pre_wal_delete_retry_script": null,
                "pre_wal_delete_script": null,
                "primary_ssh_command": null,
                "recovery_options": "get-wal",
                "retention_policy": "window 7 d",
                "retention_policy_mode": "auto",
                "reuse_backup": null,
                "slot_name": "barman",
                "ssh_command": null,
                "streaming_archiver": true,
                "streaming_archiver_batch_size": 0,
                "streaming_archiver_name": "barman_receive_wal",
                "streaming_backup_name": "barman_streaming_backup",
                "streaming_conninfo": "host=pgmaster port=5432 user=streaming_barman dbname=postgres",
                "streaming_wals_directory": "/var/lib/barman/pgmaster/streaming",
                "tablespace_bandwidth_limit": null,
                "wal_retention_policy": "simple-wal 7 d",
                "wals_directory": "/var/lib/barman/pgmaster/wals"
            },
            "status": {
                "archive_command": "barman-wal-archive backup pgmaster %p",
                "archive_mode": "on",
                "archive_timeout": 0,
                "archived_count": 0,
                "checkpoint_timeout": 300,
                "config_file": "/var/lib/pgsql/11/data/postgresql.conf",
                "connection_error": null,
                "current_archived_wals_per_second": 0.0,
                "current_lsn": "0/A000060",
                "current_size": 24719389.0,
                "current_xlog": "00000001000000000000000A",
                "data_checksums": "off",
                "data_directory": "/var/lib/pgsql/11/data",
                "failed_count": 27,
                "has_backup_privileges": true,
                "hba_file": "/var/lib/pgsql/11/data/pg_hba.conf",
                "hot_standby": "on",
                "ident_file": "/var/lib/pgsql/11/data/pg_ident.conf",
                "is_archiving": null,
                "is_in_recovery": false,
                "is_superuser": true,
                "last_archived_time": null,
                "last_archived_wal": null,
                "last_failed_time": "Tue Jul 14 10:02:14 2020",
                "last_failed_wal": "000000010000000000000005",
                "max_replication_slots": "4",
                "max_wal_senders": "4",
                "pg_basebackup_bwlimit": true,
                "pg_basebackup_compatible": true,
                "pg_basebackup_installed": true,
                "pg_basebackup_path": "/usr/pgsql-11/bin/pg_basebackup",
                "pg_basebackup_tbls_mapping": true,
                "pg_basebackup_version": "11.8",
                "pg_receivexlog_compatible": true,
                "pg_receivexlog_installed": true,
                "pg_receivexlog_path": "/usr/pgsql-11/bin/pg_receivewal",
                "pg_receivexlog_supports_slots": true,
                "pg_receivexlog_synchronous": false,
                "pg_receivexlog_version": "11.8",
                "pgespresso_installed": false,
                "postgres_systemid": "6849144001185053721",
                "replication_slot": [
                    "barman",
                    true,
                    "0/A000000"
                ],
                "replication_slot_support": true,
                "server_txt_version": "11.8",
                "stats_reset": "Tue Jul 14 04:37:04 2020",
                "streaming": true,
                "streaming_supported": true,
                "streaming_systemid": "6849144001185053721",
                "synchronous_standby_names": [
                    ""
                ],
                "timeline": 1,
                "wal_compression": "off",
                "wal_keep_segments": "20",
                "wal_level": "replica",
                "xlog_segment_size": 16777216,
                "xlogpos": "0/A000060"
            },
            "wals": {
                "last_archived_wal_per_timeline": {
                    "00000001": {
                        "compression": "gzip",
                        "name": "000000010000000000000009",
                        "size": 16461,
                        "time": 1594710068.258636
                    }
                }
            }
        }
    }
}
```

В логах barman:

```
2020-07-14 10:01:07,321 [2351] barman.server INFO: Ignoring failed check 'minimum redundancy requirements' for server 'pgmaster'
2020-07-14 10:01:07,362 [2351] barman.backup INFO: Starting backup using postgres method for server pgmaster in /var/lib/barman/pgmaster/base/20200714T100107
2020-07-14 10:01:07,385 [2351] barman.backup_executor INFO: Backup start at LSN: 0/8000060 (000000010000000000000008, 00000060)
2020-07-14 10:01:07,386 [2351] barman.backup_executor INFO: Starting backup copy via pg_basebackup for 20200714T100107
2020-07-14 10:01:07,658 [2309] barman.command_wrappers INFO: pgmaster: pg_receivewal: finished segment at 0/9000000 (timeline 1)
2020-07-14 10:01:08,340 [2309] barman.command_wrappers INFO: pgmaster: pg_receivewal: finished segment at 0/A000000 (timeline 1)
2020-07-14 10:02:02,541 [2359] barman.wal_archiver INFO: Found 2 xlog segments from streaming for pgmaster. Archive all segments in one run.
2020-07-14 10:02:02,541 [2359] barman.wal_archiver INFO: Archiving segment 1 of 2 from streaming: pgmaster/000000010000000000000008
2020-07-14 10:02:02,706 [2359] barman.wal_archiver INFO: Archiving segment 2 of 2 from streaming: pgmaster/000000010000000000000009
2020-07-14 10:02:02,869 [2359] barman.wal_archiver INFO: No xlog segments found from file archival for pgmaster.
^C
[root@barman ~]# tail -n 30 -f /var/log/barman/barman.log
2020-07-14 09:58:53,869 [2302] barman.wal_archiver INFO: No xlog segments found from file archival for pgmaster.
2020-07-14 09:58:53,974 [2302] barman.server ERROR: The WAL file 000000010000000000000006 has not been received in
30 seconds
2020-07-14 09:59:02,581 [2308] barman.wal_archiver INFO: No xlog segments found from streaming for pgmaster.
2020-07-14 09:59:02,592 [2308] barman.wal_archiver INFO: No xlog segments found from file archival for pgmaster.
2020-07-14 09:59:02,605 [2309] barman.server INFO: Starting receive-wal for server pgmaster
2020-07-14 09:59:02,701 [2309] barman.wal_archiver INFO: Activating WAL archiving through streaming protocol
2020-07-14 09:59:02,722 [2309] barman.command_wrappers INFO: pgmaster: pg_receivewal: starting log streaming at 0/6000000 (timeline 1)
2020-07-14 09:59:02,857 [2309] barman.command_wrappers INFO: pgmaster: pg_receivewal: finished segment at 0/7000000 (timeline 1)
2020-07-14 09:59:32,644 [2313] barman.server INFO: The WAL file 000000010000000000000007 has been closed on server
'pgmaster'
2020-07-14 09:59:32,656 [2313] barman.cli ERROR: Unknown server 'reset'
2020-07-14 09:59:32,782 [2309] barman.command_wrappers INFO: pgmaster: pg_receivewal: finished segment at 0/8000000 (timeline 1)
2020-07-14 09:59:46,111 [2314] barman.server INFO: Starting receive-wal for server pgmaster
2020-07-14 09:59:46,113 [2314] barman.server INFO: Another receive-wal process is already running for server pgmaster.
2020-07-14 10:00:02,655 [2321] barman.wal_archiver INFO: Found 2 xlog segments from streaming for pgmaster. Archive all segments in one run.
2020-07-14 10:00:02,655 [2321] barman.wal_archiver INFO: Archiving segment 1 of 2 from streaming: pgmaster/000000010000000000000006
2020-07-14 10:00:02,815 [2321] barman.wal_archiver INFO: Archiving segment 2 of 2 from streaming: pgmaster/000000010000000000000007
2020-07-14 10:00:02,975 [2321] barman.wal_archiver INFO: No xlog segments found from file archival for pgmaster.
2020-07-14 10:00:54,660 [2328] barman.server ERROR: Check 'minimum redundancy requirements' failed for server 'pgmaster'
2020-07-14 10:01:02,185 [2349] barman.wal_archiver INFO: No xlog segments found from streaming for pgmaster.
2020-07-14 10:01:02,186 [2349] barman.wal_archiver INFO: No xlog segments found from file archival for pgmaster.
2020-07-14 10:01:07,321 [2351] barman.server INFO: Ignoring failed check 'minimum redundancy requirements' for server 'pgmaster'
2020-07-14 10:01:07,362 [2351] barman.backup INFO: Starting backup using postgres method for server pgmaster in /var/lib/barman/pgmaster/base/20200714T100107
2020-07-14 10:01:07,385 [2351] barman.backup_executor INFO: Backup start at LSN: 0/8000060 (000000010000000000000008, 00000060)
2020-07-14 10:01:07,386 [2351] barman.backup_executor INFO: Starting backup copy via pg_basebackup for 20200714T100107
2020-07-14 10:01:07,658 [2309] barman.command_wrappers INFO: pgmaster: pg_receivewal: finished segment at 0/9000000 (timeline 1)
2020-07-14 10:01:08,340 [2309] barman.command_wrappers INFO: pgmaster: pg_receivewal: finished segment at 0/A000000 (timeline 1)
2020-07-14 10:02:02,541 [2359] barman.wal_archiver INFO: Found 2 xlog segments from streaming for pgmaster. Archive all segments in one run.
2020-07-14 10:02:02,541 [2359] barman.wal_archiver INFO: Archiving segment 1 of 2 from streaming: pgmaster/000000010000000000000008
2020-07-14 10:02:02,706 [2359] barman.wal_archiver INFO: Archiving segment 2 of 2 from streaming: pgmaster/000000010000000000000009
2020-07-14 10:02:02,869 [2359] barman.wal_archiver INFO: No xlog segments found from file archival for pgmaster.
```

В логах pgmaster:

```
ERROR: Error executing ssh: [Errno 32] Broken pipe
Exception ValueError: 'I/O operation on closed file' in <bound method _Stream.__del__ of <tarfile._Stream instance
at 0x7fe726a9b8c0>> ignored
2020-07-14 10:01:07.789 MSK [24215] LOG:  archive command failed with exit code 2
2020-07-14 10:01:07.789 MSK [24215] DETAIL:  The failed archive command was: barman-wal-archive backup pgmaster pg_wal/000000010000000000000005
ERROR: Error executing ssh: [Errno 32] Broken pipe
Exception ValueError: 'I/O operation on closed file' in <bound method _Stream.__del__ of <tarfile._Stream instance
at 0x7fb66f5ff8c0>> ignored
2020-07-14 10:01:08.377 MSK [24215] LOG:  archive command failed with exit code 2
2020-07-14 10:01:08.377 MSK [24215] DETAIL:  The failed archive command was: barman-wal-archive backup pgmaster pg_wal/000000010000000000000005
ERROR: Error executing ssh: [Errno 32] Broken pipe
Exception ValueError: 'I/O operation on closed file' in <bound method _Stream.__del__ of <tarfile._Stream instance
at 0x7f6288b478c0>> ignored
2020-07-14 10:01:09.656 MSK [24215] LOG:  archive command failed with exit code 2
2020-07-14 10:01:09.656 MSK [24215] DETAIL:  The failed archive command was: barman-wal-archive backup pgmaster pg_wal/000000010000000000000005
2020-07-14 10:01:09.656 MSK [24215] WARNING:  archiving write-ahead log file "000000010000000000000005" failed too
many times, will try again later
ERROR: Error executing ssh: [Errno 32] Broken pipe
Exception ValueError: 'I/O operation on closed file' in <bound method _Stream.__del__ of <tarfile._Stream instance
at 0x7fbb503cc8c0>> ignored
2020-07-14 10:01:09.904 MSK [24215] LOG:  archive command failed with exit code 2
2020-07-14 10:01:09.904 MSK [24215] DETAIL:  The failed archive command was: barman-wal-archive backup pgmaster pg_wal/000000010000000000000005
ERROR: Error executing ssh: [Errno 32] Broken pipe
Exception ValueError: 'I/O operation on closed file' in <bound method _Stream.__del__ of <tarfile._Stream instance
at 0x7fa68af6b8c0>> ignored
2020-07-14 10:01:11.134 MSK [24215] LOG:  archive command failed with exit code 2
2020-07-14 10:01:11.134 MSK [24215] DETAIL:  The failed archive command was: barman-wal-archive backup pgmaster pg_wal/000000010000000000000005
ERROR: Error executing ssh: [Errno 32] Broken pipe
Exception ValueError: 'I/O operation on closed file' in <bound method _Stream.__del__ of <tarfile._Stream instance
at 0x7f0cc78ff8c0>> ignored
2020-07-14 10:01:12.363 MSK [24215] LOG:  archive command failed with exit code 2
2020-07-14 10:01:12.363 MSK [24215] DETAIL:  The failed archive command was: barman-wal-archive backup pgmaster pg_wal/000000010000000000000005
2020-07-14 10:01:12.363 MSK [24215] WARNING:  archiving write-ahead log file "000000010000000000000005" failed too
many times, will try again later
```





<details><summary>Дальше рыбу заворачивал</summary>
ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" user@host


Проверяем репликацию

На мастере
postgres=# select * from pg_stat_replication;
 pid | usesysid | usename | application_name | client_addr | client_hostname | client_port | backend_start | backend_xmin | state | sent_lsn | write_lsn | flush_lsn | replay_lsn | write_lag
| flush_lag | replay_lag | sync_priority | sync_state
-----+----------+---------+------------------+-------------+-----------------+-------------+---------------+--------------+-------+----------+-----------+-----------+------------+-----------+-----------+------------+---------------+------------
(0 rows)

На слейве
postgres=# select * from pg_stat_wal_receiver;
 pid | status | receive_start_lsn | receive_start_tli | received_lsn | received_tli | last_msg_send_time | last_msg_receipt_time | latest_end_lsn | latest_end_time | slot_name | sender_host
| sender_port | conninfo
-----+--------+-------------------+-------------------+--------------+--------------+--------------------+-----------------------+----------------+-----------------+-----------+-------------+-------------+----------
(0 rows)



На слейве:
1. /usr/pgsql-11/bin/postgresql-11-setup initdb
2. Очистить содержимое /var/lib/pgsql/11/data/
3. Сделать бэкап postgresql.conf, pg_hba.conf, recovery.conf

На мастере
4. postgres=# select pg_start_backup('replication-setup',true);

На слейве
5. sudo -u postgres pg_basebackup -D /var/lib/pgsql/11/data -R -X stream -c fast -P -d 'host=192.168.11.20 user=replication'

После этого процесс postgresql на слейве упадет, если заведомо не будет подходящим образом сконфигурирован pg_hba.conf мастера, в этом случае надо вернуть конфиги слейва на место.

На мастере
6. postgres=# select pg_stop_backup();

На слейве
7. systemctl start postgresql-11


Проверяем
На мастере
postgres=# select * from pg_stat_replication;
  pid  | usesysid |   usename   | application_name |  client_addr  | client_hostname | client_port |         backend_start         | backend_xmin |   state   |  sent_lsn  | write_lsn  | flush_lsn  | replay_lsn | write_lag | flush_lag | replay_lag | sync_priority | sync_state
-------+----------+-------------+------------------+---------------+-----------------+-------------+-------------------------------+--------------+-----------+------------+------------+------------+------------+-----------+-----------+------------+---------------+------------
 31117 |    16384 | replication | walreceiver      | 192.168.11.21 |                 |       37132 | 2020-07-11 01:55:35.162275+03 |              | streaming | 0/20000060 | 0/20000060 | 0/20000060 | 0/20000060 |           |           |            |             0 | async
(1 row)


На слейве
postgres=# select * from pg_stat_wal_receiver;
  pid  |  status   | receive_start_lsn | receive_start_tli | received_lsn | received_tli |
 last_msg_send_time       |     last_msg_receipt_time     | latest_end_lsn |        latest_end_time        |  slot_name   |  sender_host  | sender_port |
                                                          conninfo

-------+-----------+-------------------+-------------------+--------------+--------------+-------------------------------+-------------------------------+----------------+-------------------------------+--------------+---------------+-------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 24808 | streaming | 0/1F000000        |                 1 | 0/20000060   |            1 | 2020-07-11 01:56:18.643987+03 | 2020-07-11 01:56:18.644719+03 | 0/20000060     | 2020-07-11 01:55:48.597915+03 | standby_slot | 192.168.11.20 |        5432 | user=replication password=******** dbname=replication host=192.168.11.20 port=5432 fallback_application_name=walreceiver sslmode=prefer sslcompression=0 krbsrvname=postgres target_session_attrs=any
(1 row)


На мастере
postgres=# create database test222;
CREATE DATABASE

На слейве
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 demo      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 test      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 test222   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
(6 rows)


archive_mode    = on
archive_command = 'cp %p /var/lib/pgsql/11/backups/%f'

5 0 * * * find /var/lib/pgsql/11/backups/ -mtime +7 -exec rm -f {} \;






Barman


barman show-server pgmaster
barman receive-wal --create-slot pgmaster
barman receive-wal pgmaster
barman check pgmaster

cat > /var/lib/barman/.pgpass
chmod 0600 /var/lib/barman/.pgpass


export PATH=$PATH:/usr/pgsql-11/bin


barman switch-wal pgmaster

если не срабатывает, то:

barman reset pgmaster

и потом снова 

barman switch-wal pgmaster




barman switch-wal --force --archive pgmaster

и затем снова 

barman backup pgmaster
</details>