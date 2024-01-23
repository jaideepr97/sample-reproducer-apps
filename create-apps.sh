#!/bin/bash
mkdir -p "apps"

for i in {1..100}
do
  for j in {1..5}
  do
    app_name="sample-app-$((5*(i-1) + j))"
    output_file="apps/$app_name.yaml"
    
    cat <<EOF > "$output_file"
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $app_name
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

echo "YAML files for creating applications have been saved."
