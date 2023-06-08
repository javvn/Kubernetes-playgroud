#!/bin/zsh

#FILE_PATH=/Users/jawn/Workspace/kubernetes/building-cluster/ansible/repo/docker-set.sh
#
#if [ -f "$FILE_PATH" ]
#  then
#    echo "file existed"
#  else
#    echo "file not existed"
#fi
#
#grep -Fxq "./host-test" "./host-list"

if grep -F ./host-test ./host-list
  then
    echo "found"
  else
    echo "not found"
fi

#cat > test.dd <<EOF
#192.168.64.5 master1.kubernetes.lab
#192.168.64.7 worker1.kubernetes.lab
#192.168.64.8 worker2.kubernetes.lab
#EOF