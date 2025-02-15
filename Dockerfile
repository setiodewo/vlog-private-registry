FROM nginx:latest

VOLUME "/etc/nginx/conf.d"

RUN apt update && apt install apache2-utils nano -y
