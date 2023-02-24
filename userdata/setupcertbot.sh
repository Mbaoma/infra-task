#! /bin/bash
sudo mkdir /ssl/private
sudo mkdir /ssl/certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/private/nginx-selfsigned.key -out /etc/nginx/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/nginx/ssl/certs/dhparam.pem 2048