#!/bin/bash
# Usage:
#       ./k8s_admin_shell.sh [host-shell:boolean] [node-name]
# E.g.:
# Start as Host shell:
#       ./k8s_admin_shell.sh true
#
# Start as Pod-network shell:
#       ./k8s_admin_shell.sh
#       ./k8s_admin_shell.sh false kube-system
#
set -euo pipefail

privileged=${1:-false}
namespace=${2:-default}
k8s_yaml="k8s/k8s-admin-shell.yaml"
command="bash"
if $privileged; then
  echo "WARNING: Creating privileged host shell"
  k8s_yaml="k8s-privileged/k8s-admin-privileged-shell.yaml"
  command="nsenter --target 1 --mount --uts --ipc --net /bin/bash"
fi
kubectl apply -f "$(dirname "$0")/$k8s_yaml" -n "$namespace"
# wait for pod to run
while [ "$(kubectl get po k8s-admin-shell -n "$namespace" -o jsonpath='{.status.phase}')" != "Running" ]; do
  sleep 1
done
# Exec into pod
kubectl exec -it k8s-admin-shell -n "$namespace" -- $command
# Delete pod after shell was closed
kubectl delete --force po -n "$namespace" k8s-admin-shell

