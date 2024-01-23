#!/bin/bash

for i in {1..50}
do
  for j in {1..5}
  do
    cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sample-app-$((5*(i-1) + j))
  namespace: project-gitops
spec:
  destination:
    namespace: ns-$i
    server: https://kubernetes.default.svc
  project: default
  source:
    path: manifests-$((5*(i-1) + j))
    repoURL: https://github.com/jaideepr97/sample-reproducer-apps
    targetRevision: main
  syncPolicy:
    automated:
      prune: true 
      selfHeal: true
EOF
  done
done 