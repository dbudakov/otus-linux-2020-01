FROM alpine:3.11
LABEL maaintainer=OTUS
WORKDIR /home/vagrant
EXPOSE 80
RUN apk add nginx ; \
mkdir /run/nginx && touch /run/nginx/nginx.pid ; \
echo "daemon off;" >> /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /var/www/index.html
CMD /usr/sbin/nginx -c /etc/nginx/nginx.conf
