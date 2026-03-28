#!/bin/bash
sudo yum update -y && sudo yum install -y nginx
sudo chmod 766 /usr/share/nginx/html/index.html
sudo echo "Hello from $(hostname)" > /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx