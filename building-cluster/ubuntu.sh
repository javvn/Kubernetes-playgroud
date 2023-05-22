#!/bin/bash

# CPU : 6
# Memory : 8192

sudo passwd root

sudo apt update
sudo apt install openssh-server git-all

# Already installed, automatic
sudo apt install apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Install golang
sudo wget https://golang.org/dl/go1.20.4.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.20.4.linux-arm64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# /etc/ssh/ssh_config << ssh config file

# CPU , Memory , Process check
htop

# Total physic disk
lsblk
# or
fdisk -l

# https://docs.docker.com/engine/install/ubuntu/
# install docker
sudo apt remove docker docker-engine docker.io containerd runc

ll /var/lib | grep docker # if 'docker' directory is empty, remove directory

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

service docker status
service docker start

# Install cri-dockerd
# https://github.com/Mirantis/cri-dockerd
# https://kubernetes.io/ko/docs/setup/production-environment/container-runtimes/#docker
git clone https://github.com/Mirantis/cri-dockerd.git
mkdir cri-dockerd/bin
go build -o bin/cri-dockerd
mkdir -p /usr/local/bin
sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
sudo cp -a packaging/systemd/* /etc/systemd/system
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket


# install kubectl
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
sudo chmod a+r /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install kubectl=1.26.0-00
kubectl version --output=yaml

sudo swapoff -a && sudo sed -i '/swap/s/&/#/' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo hostnamectl set-hostname master

sudo ufw disable

sudo swapon && sudo cat /etc/fstab
sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

# install kubelet kubeadm
sudo apt-get install -y \
  kubelet=1.26.0-00 \
  kubeadm=1.26.0-00

sudo apt-mark hold kubelet kubeadm kubectl

kubectl version -o yaml
kubeadm version -o yaml
kubelet --version



# CRI-O as CRI
# https://github.com/cri-o/cri-o/blob/main/install.md#apt-based-operating-systems
# https://ko.linux-console.net/?p=3476#gsc.tab=0
export OS=xUbuntu_22.04
export VERSION=1.26.3

sudo curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/libcontainers-archive-keyring.gpg

sudo curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.26:/1.26.3/xUbuntu_22.04/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/libcontainers-crio-archive-keyring.gpg

sudo echo "deb [signed-by=/etc/apt/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
sudo echo "deb [signed-by=/etc/apt/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.26/$OS/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

sudo apt update
sudo apt install cri-o cri-o-runc cri-tools
sudo apt install containernetworking-plugins

sudo systemctl status crio
sudo systemctl start crio
sudo systemctl enable crio

sudo vi /etc/crio/crio.conf
# network_dir = "/etc/cni/net.d/"
# plugin_dirs = ["/opt/cni/bin/", "/usr/lib/cni/"]


rm -f /etc/cni/net.d/100-crio-bridge.conf
sudo curl -fsSLo /etc/cni/net.d/11-crio-ipv4-bridge.conf https://raw.githubusercontent.com/cri-o/cri-o/main/contrib/cni/11-crio-ipv4-bridge.conf




sudo kubeadm config images list

# https://lifeplan-b.tistory.com/167
#sudo kubeadm config images pull --cri-socket /var/run/cri-dockerd.sock

# kubeadm init --apiserver-advertise-address=<api 서버 IP> --pod-network-cidr=192.168.0.0/16 --cri-socket /var/run/crio/crio.sock


# kubeadm init --apiserver-advertise-address=<api 서버 IP> --pod-network-cidr=192.168.0.0/16 --cri-socket /var/run/crio/crio.sock
#sudo kubeadm init --apiserver-advertise-address=<api 서버 IP> --pod-network-cidr=192.168.0.0/16 --cri-socket /var/run/crio/crio.sock
#sudo kubeadm init --pod-network-cidr= --upload-certs
sudo kubeadm config images pull --image-repository=registry.k8s.io --cri-socket unix:///run/cri-dockerd.sock --kubernetes-version v1.26.0
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=192.168.64.4 --kubernetes-version=v1.26.0 --cri-socket unix:///run/cri-dockerd.sock


# Reset kubeadm
docker ps -aq --filter name=nginx
docker container rm -f $(docker ps -aq --filter name=k8s)
docker volume rm $(docker volume ls -q)
sudo umount /var/lib/docker/volumes
sudo rm -rf /var/lib/docker/
sudo systemctl restart docker
sudo reboot
#  mkdir -p $HOME/.kube
#  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#  sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
#Alternatively, if you are the root user, you can run:
#
#  export KUBECONFIG=/etc/kubernetes/admin.conf
#
#Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#  https://kubernetes.io/docs/concepts/cluster-administration/addons/

#You can now join any number of control-plane nodes by copying certificate authorities
#and service account keys on each node and then running the following as root:
#
#  kubeadm join 192.168.64.4:6443 --token gan1qr.bpbuq89ubgpejblq \
#	--discovery-token-ca-cert-hash sha256:f719e1ca54edc3d1ac13abed308941eacc7e41a62a599573ad53dcb7d735adc3 \
#	--control-plane

#Then you can join any number of worker nodes by running the following on each as root:
#
#kubeadm join 192.168.64.4:6443 --token gan1qr.bpbuq89ubgpejblq \
#	--discovery-token-ca-cert-hash sha256:f719e1ca54edc3d1ac13abed308941eacc7e41a62a599573ad53dcb7d735adc3