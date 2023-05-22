# Bootstrapping clusters with kubeadm

## Setting Container Runtime Interface ( Docker )

```bash

sudo apt remove docker docker-engine docker.io containerd runc

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo service docker status

sudo service docker start

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
```

## Install kubectl

```bash
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

```

## Install kubelet kubeadm

```bash
sudo apt-get install -y \
  kubelet=1.26.0-00 \
  kubeadm=1.26.0-00

sudo apt-mark hold kubelet kubeadm kubectl

kubectl version -o yaml

kubeadm version -o yaml

kubelet --version
```

## Config kubeadm

```bash
sudo kubeadm config images list

sudo kubeadm config images pull --image-repository=registry.k8s.io --cri-socket unix:///run/cri-dockerd.sock --kubernetes-version v1.26.0

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=192.168.64.4 --kubernetes-version=v1.26.0 --cri-socket unix:///run/cri-dockerd.sock
```



# Ref 
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
- https://velog.io/@khyup0629/k8s-쿠버네티스-전체-아키텍처-이해
- https://kindloveit.tistory.com/23
- https://kubernetes.io/docs/concepts/cluster-administration/addons/
- https://mlops-for-all.github.io/docs/setup-kubernetes/install-prerequisite/
- https://mlops-for-all.github.io/docs/setup-kubernetes/kubernetes-with-kubeadm/
- https://velog.io/@seunghyeon/Kubeadm으로-K8S-구성
- https://velog.io/@sjoh0704/kubeadm으로-K8S-cluster-구축하기feat.-cri-o
- https://blog.kubesimplify.com/kubernetes-126
- https://confluence.curvc.com/pages/releaseview.action?pageId=98048155#Ubuntu에서쿠버네티스(k8s)설치가이드-자동완성설정(master)
- https://akyriako.medium.com/install-kubernetes-on-ubuntu-20-04-f1791e8cf799
- https://akyriako.medium.com/create-a-multi-node-kubernetes-cluster-with-vagrant-542accaad51f
- https://velog.io/@jopopscript/kubernetes-설치on-ubuntu