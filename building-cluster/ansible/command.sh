#!/bin/bash

alias playbook=ansible-playbook

sudo su

cat > ~/.ansible.cfg <<EOF
[defaults]
host_key_checking = False
EOF

cat > /etc/sudoers.d/"$(whoami)" <<EOF
"$(whoami)" ALL=(ALL) NOPASSWD: ALL
EOF
# https://www.ansiblepilot.com/articles/ansible-troubleshooting-missing-sudo-password/