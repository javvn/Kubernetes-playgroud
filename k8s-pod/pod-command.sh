#!/bin/bash

alias k=kubectl

k api-resources | grep pod

k explain pod

########################################

# Pod List
kubectl get pod

# Describe status of specific pod
kubectl describe pod [POD_NAME]

# Delivery command to specific pod
kubectl exec -i -t [POD_NAME] [COMMAND]
kubectl exec -i -t [POD_NAME] -c debug [COMMAND]

# Inspect log specific pod
kubectl logs pod/[POD_NAME]
kubectl logs pod/[POD_NAME] -c debug

# Apply
kubectl apply -f pod.yaml

# Get running API
kubectl get pod
kubectl get pod -o wide

# Delete
kubectl delete -f pod.yaml

########################################

minikube start

minikube ssh
