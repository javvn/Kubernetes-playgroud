#!/bin/bash

alias playbook=ansible-playbook

cat > ~/.ansible.cfg <<EOF
[defaults]
host_key_checking = False
EOF

