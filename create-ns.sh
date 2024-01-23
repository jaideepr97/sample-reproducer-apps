#!/bin/bash

for i in {1..100}
do
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ns-$i
  labels:
    argocd.argoproj.io/managed-by: project-gitops
EOF
done
