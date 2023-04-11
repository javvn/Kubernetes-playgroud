#!/bin/zsh

watch kubectl get pod --show-labels

kubectl edit pod POD_NAME

kubectl delete pod POD_NAME