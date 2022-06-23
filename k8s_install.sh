#!/bin/bash

# Firewall off
sudo systemctl stop ufw
sudo systemctl disable ufw

# Essential package install(docker, k8s)
sudo apt update
sudo apt-get update
sudo apt-get install -y openssh-server \\
net-tools \\
ca-certificates \\
curl \\
software-properties-common \\
apt-transport-https \\
gnupg \\
lsb-release \\
nftables

# Swap memory off
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# k8s install
sudo apt -y full-upgrade

# key regist
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
# # sudo apt-get install -y kubelet=<version> kubeadm=<version> kubectl=<version>
sudo apt-mark hold kubelet kubeadm kubectl

sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl enable kubelet

# Automatic command completion
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >>~/.bashrc
source <(kubeadm completion bash)
echo "source <(kubeadm completion bash)" >>~/.bashrc
