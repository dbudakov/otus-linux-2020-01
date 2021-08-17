## Домашнее задание  
Развернуть InnoDB кластер в docker  
Цель: В результате выполнения ДЗ студент развернет InnoDB кластер в docker.  
развернуть InnoDB кластер в docker  
* в docker swarm  
  
в качестве ДЗ принимает репозиторий с docker-compose  
который по кнопке разворачивает кластер и выдает порт наружу  
  
## Решение  
https://mysqlrelease.com/2018/03/docker-compose-setup-for-innodb-cluster/
  
Предварительная настройка ВМ включена(!) в Vagrantfile  

```
# Install docker and docker-compose
yum install -y docker && systemctl start docker && systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# docker-compose up
cd /vagrant/mysql-docker-compose-examples/innodb-cluster/ && docker-compose up
```

После деплоя стенда `MySQL Router` будет доступен от хостовой виртуальной машины по команде

```
mysql -h  172.18.0.6 -u root  -P 6446
```

Для доступа к базе используется другая учетная запись

```
mysql -h  172.18.0.6 -u dbwebapp -pdbwebapp  -P 6446
```

Далее для проверки работы кластера предлагаются следующие действия

Запись ключа доступа для передачи команд

```
# Create key
docker exec -it innodb-cluster_mysql-router_1 bash -c "echo [client] > /root/.my.cnf"
docker exec -it innodb-cluster_mysql-router_1 bash -c "echo password=mysql >> /root/.my.cnf"
```

Проверка хостов в кластере

```
# Check hosts
docker exec -it innodb-cluster_mysql-router_1 bash -c 'mysql -e "select * from mysql_innodb_cluster_metadata.hosts;"'
```

Создание таблицы и записей, с использованием `PRIMARY KEY`

```
# Create table
docker exec -it innodb-cluster_mysql-router_1 bash -c 'mysql -e "CREATE TABLE dbwebappdb.Customers ( Id INT, Age INT, FirstName VARCHAR(20), LastName VARCHAR(20), PRIMARY KEY (Id, Age, FirstName, LastName));"'
docker exec -it innodb-cluster_mysql-router_1 bash -c 'mysql -e "INSERT INTO dbwebappdb.Customers VALUES (1, 21, \"test_1\", \"string_1\");"'
docker exec -it innodb-cluster_mysql-router_1 bash -c 'mysql -e "INSERT INTO dbwebappdb.Customers VALUES (2, 22, \"test_2\", \"string_2\");"'
docker exec -it innodb-cluster_mysql-router_1 bash -c 'mysql -e "SELECT * FROM dbwebappdb.Customers";'
```

Проверка записи на 1'ом сервере

```
# Check table other host: innodb-cluster_mysql-server-1_1
docker exec -it innodb-cluster_mysql-server-1_1 bash -c "echo [client] > /root/.my.cnf"
docker exec -it innodb-cluster_mysql-server-1_1 bash -c "echo password=dbwebapp >> /root/.my.cnf"
docker exec -it innodb-cluster_mysql-server-1_1 bash -c 'mysql -u dbwebapp -e "SELECT * FROM dbwebappdb.Customers";'
```

Проверка записи на 2'ом сервере

```
# Check table other host: innodb-cluster_mysql-server-2_1
docker exec -it innodb-cluster_mysql-server-2_1 bash -c "echo [client] > /root/.my.cnf"
docker exec -it innodb-cluster_mysql-server-2_1 bash -c "echo password=dbwebapp >> /root/.my.cnf"
docker exec -it innodb-cluster_mysql-server-2_1 bash -c 'mysql -u dbwebapp -e "SELECT * FROM dbwebappdb.Customers";'
```
### Дополнительно  
[ProxySQL Admin](https://github.com/percona/proxysql-admin-tool)     
[Load balancing with ProxySQL](https://www.percona.com/doc/percona-xtradb-cluster/LATEST/howtos/proxysql.html)    
Percona Monitoring & Management (PMM) Essentials [link](https://dinfratechsource.com/2018/11/10/percona-monitoring-management-pmm-essentials/)  
