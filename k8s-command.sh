#!/bin/zsh


kubectl api-resources | grep API_RESOURCE
kubectl explain API_RESOURCE

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

# Get running API
kubectl get pod
kubectl get pod -o wide


watch kubectl get pod --show-labels

kubectl edit pod POD_NAME

kubectl delete pod POD_NAME

kubectl rollout history deployment NAMESPACE

kubectl set image deployment NAMESPACE go=ezuoo/go:latest --record

kubectl rollout undo deployment NAMESPACE --to-revision=REVISION

kubectl rollout status deployment NAMESPACE


# create secret key with type generic
kubectl create secret generic MY_SECRET

# create secret key
kubectl create secret generic MY_SECRET --from-file secret.yaml

kubectl create secret generic MY_SECRET --from-file secret=secret.yaml



