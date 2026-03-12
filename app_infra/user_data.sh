#!/bin/bash
set -eux

# Update system
dnf update -y

# Install Docker
dnf install -y docker

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Allow ec2-user to run docker without sudo
usermod -aG docker ec2-user

#login to ECR
#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 455025093404.dkr.ecr.us-east-1.amazonaws.com

#pull docker image
#docker pull 455025093404.dkr.ecr.us-east-1.amazonaws.com/cicd-python-app:latest

#run container
#docker run -d -p 80:5000 455025093404.dkr.ecr.us-east-1.amazonaws.com/cicd-python-app:latest

#install Nginx
sudo dnf install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

#Nginx Reverse Proxy Default COnfig
sudo bash -c 'cat > /etc/nginx/conf.d/cicd-app.conf <<EON
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;  # Docker container port
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
}
EON'

#Test Nginx config and restart

sudo nginx -t
sudo systemctl restart nginx