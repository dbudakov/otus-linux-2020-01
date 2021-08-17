#!/bin/bash

## Проверка версии make
yum install bc -y
yum list installed make > ./install_log || yum install make -y >> ./install_log
echo $(make --version | awk '/GNU Make/ {print $NF}') >= 3.8|bc  >> ./install_log || yum update make -y >> ./install_log

## Проверка наличия gcc
for i in gcc tar gzip bzip2
do yum list installed $i >> ./install_log || yum install $i -y >> ./install_log
done

## Аналог history для psql, можно отключить указав --without-readline для configure, а также собрать альтернативу
#configure --with-libedit-preferred
yum install readline readline-devel zlib-devel.x86_64  -y


## Для отключения сжатия pg_dump и pg_restore указать --without-zlib для configure

# Поддержка perl, python, tlc, language support см. документацию
# https://postgrespro.ru/docs/postgresql/9.4/install-requirements

# В случае необходимости аутентификации или шифрования могут потребоваться Kerberos, OpenSSL, OpenLDAP и/или PAM

# Также проверьте, достаточно ли места на диске. Вам потребуется около 100 Мб для исходного кода в процессе компиляции и около 20 Мб для каталога инсталляции. Пустой кластер баз данных занимает около 35 Мб; базы данных занимают примерно в пять раз больше места, чем те же данные в обычном текстовом файле. Если вы планируете запускать регрессионные тесты, вам может временно понадобиться ещё около 150 Мб. Проверить наличие свободного места можно с помощью команды df.

## Загрузка исходников
curl -o postgresql-9.4.1.tar.gz  https://ftp.postgresql.org/pub/source/v9.4.1/postgresql-9.4.1.tar.gz
gunzip postgresql-9.4.1.tar.gz
tar xf postgresql-9.4.1.tar

## Далее нужно сконфигурировать дерево каталогов, операция создает дерево каталогов в текущем местоположении, если вы находитесь в другой директории дерево будет создано там
## опции сборки https://postgrespro.ru/docs/postgresql/9.4/install-procedure
## по дефолту вся установка пойдет в /usr/local/pgsql
./configure

## Запуск сборки
make

## Сборка документации
# make world

## Регрессиные тесты
# make check

## Установка PostgreSQL
make install

## Для установки документации и страниц man
make install-docs
## или если задействовался world
# make install-world

## Установка только клиентской части
# make -C src/bin install
# make -C src/include install
# make -C src/interfaces install
# make -C doc install

## Удаление
# make uninstall
## Удаление файлов, не затрагивая каталоги созданные configure
# make clean
## Возврат к дефолтному состоянию с удалением каталогов созданных configure
# make distclean

sed -i '/PATH/d' ~/.bashrc
cat<<EOF>>~/.bashrc
PATH="$PATH:/usr/local/pgsql/bin"
EOF
