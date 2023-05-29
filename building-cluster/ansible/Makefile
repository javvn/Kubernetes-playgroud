into-default-hn:
	ansible-playbook -i inventory kubeadm.yaml --tags "set-default-hostname"

into-k8s-hn:
	ansible-playbook -i inventory kubeadm.yaml --tags "set-k8s-hostname"

set-hosts:
	ansible-playbook -i inventory kubeadm.yaml --tags "set-hosts"

debug-hosts:
	ansible-playbook -i inventory kubeadm.yaml --tags "debug-hosts"

debug-ansible-facts:
	ansible-playbook -i inventory kubeadm.yaml --tags "debug-ansible-facts"