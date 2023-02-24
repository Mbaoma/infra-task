#! /bin/bash
sudo apt update -y &&
sudo apt install -y nginx

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