#!/usr/bin/env bash
# a Bash script that sets up your web servers for the deployment of web_static


# get package updates
apt update

# create the neccessary directories
apt -y install nginx

# create the neccessary folder if they dont exist
mkdir -p /data/web_static/shared/
mkdir -p /data/web_static/releases/test/

# make a fake html file to test the nginx configuration
printf "<!DOCTYPE html>\n<html lang="en">\n<head>\n</head>\n<body>\n\t<p>Hello Everyone!</p>\n</body>\n</html>" | tee /data/web_static/releases/test/index.html

# create a sym link of /data/web_static/current to /data/web_static/releases/tests
ln -sf /data/web_static/releases/test/ /data/web_static/current

# recursively give ownership to the /data directory to the ubuntu user and group
chown -R ubuntu:ubuntu /data/

# update nginx configuration files
loc_header="location \/hbnb\_static\/ {"
loc_content="alias \/data\/web\_static\/current\/;"
new_location="\n\t$loc_header\n\t\t$loc_content\n\t}\n"
sed -i "37s/$/$new_location/" /etc/nginx/sites-available/default

# Restart Nginx
service nginx restart
