#!/bin/bash

sudo apt-get update

# Essential package install(docker, k8s)
sudo apt-get install -y openssh-server \\
net-tools \\
ca-certificates \\
curl \\
software-properties-common \\
apt-transport-https \\
gnupg \\
lsb-release \\
nftables

# Docker Official GPG Key is register
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# stable repository is register
sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Docker Engine install
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
#sudo apt-get install -y docker-ce=<version> docker-ce-cli=<version> containerd.io=<version>
sudo systemctl enable docker

# Docker compose install
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add user permisson
sudo usermod -aG docker $USER
