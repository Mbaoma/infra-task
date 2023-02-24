#! /bin/bash
sudo amazon-linux-extras install nginx1 -y &&
sudo amazon-linux-extras install epel -y   &&
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y &&
sudo yum install certbot python-certbot-nginx &&
sudo systemctl start nginx

# Set the file name and directory path
file_name="index.html"
dir_path="/usr/share/nginx/html"

# Create the directory if it doesn't exist
mkdir -p "$dir_path"

# Write the HTML to the file
sudo cat <<EOF > "$dir_path/$file_name"
<!DOCTYPE html>
<html>
<head>
	<title>Hello World</title>
</head>
<body>
	<h1>Hello World!</h1>
</body>
</html>
EOF

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/private/nginx-selfsigned.key -out /etc/nginx/ssl/certs/nginx-selfsigned.crt
