#! /bin/bash
sudo apt update -y 
sudo apt install -y nginx
sudo apt install -y nginx-core
sudo systemctl start nginx
sudo systemctl enable nginx
sudo apt install certbot python3-certbot-nginx -y
sudo echo "<head><title>Hello World</title></head><body><h1>You can edit this page on every pull request.</h1><br>Thank you</body>" | sudo tee /var/www/html/index.nginx-debian.html
sudo nginx -t

# # sudo mkdir /ssl/private
# # sudo mkdir /ssl/certs
# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/private/nginx-selfsigned.key -out /etc/nginx/ssl/certs/nginx-selfsigned.crt
# sudo openssl dhparam -out /etc/nginx/ssl/certs/dhparam.pem 2048
# #sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/private/nginx-selfsigned.key -out /etc/nginx/ssl/certs/nginx-selfsigned.crt
