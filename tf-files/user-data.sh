#! /bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker $USER
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install git -y
git clone https://github.com/Morgoliath/203-Dockerization.git
cd 203-Dockerization/Docker
docker build -t "morgoliath/bookstore-api:1.0" .
docker-compose up -d
hostnamectl set-hostname "docker-project-server"
bash
