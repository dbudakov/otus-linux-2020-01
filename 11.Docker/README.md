## Домашнее задание  
  
Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)      
Определите разницу между контейнером и образом. Вывод опишите в домашнем задании.    
Ответьте на вопрос: Можно ли в контейнере собрать ядро?
Собранный образ необходимо запушить в docker hub и дать ссылку на ваш репозиторий.  

## Решение
1.Разница между контейнером и образом, заключается в том что образ это коробра для контейра из которого и разворачивается контейнер,  

2.Можно ли в контейнере собрать ядро?   
Ответ: думаю да, также скачать исходники или зааттачить из хоста, вместе с `config` текущего ядра, дальше сборка ядра по сценарию, как на обычной ОС. Можно ли запустить контейнер на альтернативном ядре, слышал что да, но не интересовался этой темой, думаю это собирается в `Dockerfile`. 

Установка `docker` [офиц. здесь](https://docs.docker.com/engine/install/centos/) и [здесь](https://1cloud.ru/help/linux/instruktsiya-docker-na-centos7)    
```
sudo yum check-update
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker <имя пользователя> 
sudo systemctl start docker
#sudo systemctl enable docker
```
Установка `docker-compose` [здесь](https://docs.docker.com/compose/install/)    
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

Cодержание `Dockerfile`:      
```
FROM alpine:3.11        # базовая архитектура контейнера
WORKDIR /home/vagrant   # рабочая директория, будут являтся точкой отсчёта для контейнера
EXPOSE 80               # открывает 80 порт для общения контейнера и хоста
RUN apk add nginx ; \   # установка nginx
mkdir /run/nginx && touch /run/nginx/nginx.pid ; \  # создание необходимых директорий
echo "daemon off;" >> /etc/nginx/nginx.conf         # настройка nginx для автономной работы
COPY default.conf /etc/nginx/conf.d/default.conf    # копия настроек nginx для тестовой страницы
COPY index.html /var/www/index.html                 # копия самой тестовой страницы
CMD /usr/sbin/nginx -c /etc/nginx/nginx.conf        # запуск nginx использою указанный конфиг

```


Для сборки контейнера набираем следующую команду:   
```
docker build -t lesson_nginx . --no-cache
## здесь:
#  -t [name]  - это наименование будущего image 
#  .          - обозначает текущую директория
#  --no-cache - значит не использовать кэш предыдущих сборок
```
Далее заливаем полученный `image` на `dockerhub`
```
docker tag  lesson_nginx  dbudakov/lesson:lesson_nginx

docker login
docker push dbudakov/lesson:lesson_nginx
```
 
Для проверки загруженного контейнера на репозиторий можно выполнить  
```
docker run -d dbudakov/lesson:lesson_nginx
curl $(docker inspect --format {{.NetworkSettings.IPAddress}} $(docker ps|awk '/dbudakov/ {print $1}'))
or
docker pull docker pull dbudakov/lesson:lesson_nginx
docker run -d $(docker ps|awk '/dbudakov/ {print $1}')
```
#### Дополнительные материалы    
```
docker tag [image] [repository]:[image]  # затагировать image для заливки  
docker push [repository]:[image]         # залить image 
```
основные команды:  
```
docker build -t lesson_nginx . --no-cache - сборка контейнера(описание выше)
docker ps -a - список запущенных контейнеров
docker rm 42139d 355da53 - удаление созданных контейнеров
docker images - список images
docker rmi 5cdskiah - удаление image по идентификатору
docker system prune -a - удалить устарешие созданные контейнеры
docker run -p 80:80 nginx - запуск контейра от imange-nginx с прокинутым 80 портом с хоста
docker exec -it d3df35d bash - войти в контейнер с оболочкой bash
docker logs 352dsfa35 - события по контейнеру
docker inspect 352dsfa35
docker run -d --rm --name u1 ubuntu
docker run -d --name u1 ubuntu sleep 3000
docker run -d --name u2 --network=mybridge ubuntu sleep 3000
docker network ls
docker network inspect
docker stop 5a1f377 5020b13 60cae22


docker-compose up - интерактивный режим сборки
docker-compose up -d - деплой списка контейнеров заданных в .yml  файле
docker-compose up --build -d - пересобрать контейнер из текущей дирректории
docker logs [id] - выводит логи по контейнеру
docker ps -lq - выводит id
  
```
Вывод информации по контейнерам [link](https://docs.docker.com/engine/reference/commandline/ps/)  
```sh
# вывести ID и Name
docker ps --format "table {{.ID}}\t{{.Names}}"

# вывод файла логов для контейнера
docker inspect rocketchat_rocketchat_1 |grep -E "LogPath"

# зачистить логи контейнера
echo "" > $(docker inspect --format='{{.LogPath}}' <container_name_or_id>)

```
заметки  
```sh
# переход в контейнер 
echo -n "write container id/name: " ; read a; docker exec -it $a bash
```
#### Дополнительно
microbadger.com - множество собранных контейнеров  
Права пользователю на запуск контейнеров, требует `systemd v226` [здесь](https://superuser.com/questions/1064616/polkit-systemd-interaction),  [update systemd](https://copr.fedorainfracloud.org/coprs/jsynacek/systemd-backports-for-centos-7/),  [update systemd source](https://github.com/systemd/systemd/releases)    
[Как nginx указать на php-fpm на другом докере?](https://qna.habr.com/q/597608)  
[Nginx](https://wiki.alpinelinux.org/wiki/Nginx)  
UCP requires IPv4 IP Forwarding(форвардинг портов Docker) [здесь](https://success.docker.com/article/ipv4-forwarding)  
