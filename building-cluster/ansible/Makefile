into-default-hn:
	ansible-playbook -i inventory kubeadm.yaml --tags "set-default-hostname"

setup-k8s-cluster:
	ansible-playbook -i inventory kubeadm.yaml --tags "setup-k8s-cluster" --skip-tags="set-hosts"


into-k8s-hn:
	ansible-playbook -i inventory kubeadm.yaml --tags "set-k8s-hostname"

set-hosts:
	ansible-playbook -i inventory kubeadm.yaml --tags "set-hosts"

debug-hosts:
	ansible-playbook -i inventory kubeadm.yaml --tags "debug-hosts"

debug-env:
	ansible-playbook -i inventory kubeadm.yaml --tags "debug-env"

debug-hostvars:
	ansible-playbook -i inventory kubeadm.yaml --tags "debug-hostvars"


debug-ansible-facts:
	ansible-playbook -i inventory kubeadm.yaml --tags "debug-ansible-facts"

debug-register:
	ansible-playbook -i inventory kubeadm.yaml --tags "debug-register"

ansible-host:
	ansible-playbook -i inventory kubeadm.yaml --tags "ansible-host"



reboot-all:
	ansible-playbook -i inventory kubeadm.yaml --tags "reboot"

install-kubeadm:
	ansible-playbook -i inventory kubeadm.yaml --tags "set-k8s"

load-kernel-mod:
	ansible-playbook -i inventory kubeadm.yaml --tags "load-kernel-mod"

setting-kernel:
	ansible-playbook -i inventory kubeadm.yaml --tags "setting-kernel"

init-kubeadm:
	ansible-playbook -i inventory kubeadm.yaml --tags "init-kubeadm"

enable-kubelet:
	ansible-playbook -i inventory kubeadm.yaml --tags "enable-kubelet"

config-kubectl:
	ansible-playbook -i inventory kubeadm.yaml --tags "config-kubectl"