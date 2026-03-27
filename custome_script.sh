#!/bin/bash
sudo yum update -y && sudo yum install -y nginx
echo "Hello from $(hostname)" > /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx