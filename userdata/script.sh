#! /bin/bash
sudo yum update -y &&
sudo yum install -y nginx
sudo yum install certbot python3-certbot-nginx -y

# Set the file name and directory path
file_name="index.html"
dir_path="/var/www/html"

# Create the directory if it doesn't exist
mkdir -p "$dir_path"

# Write the HTML to the file
cat <<EOF > "$dir_path/$file_name"
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