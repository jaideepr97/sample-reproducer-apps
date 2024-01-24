#!/bin/bash

# Get a list of namespaces with Argo CD instances
argocd_namespaces=$(oc get ArgoCD --all-namespaces -o jsonpath='{.items[*].metadata.namespace}')

# Get a list of managed namespaces of namespaces with ArgoCD instances
for argocd_namespace in $argocd_namespaces; do
    argocd_managedNamespaces+=$(oc get namespaces --selector=argocd.argoproj.io/managed-by="${argocd_namespace}" -o jsonpath='{.items[*].metadata.name}')
done

all_namespaces="${argocd_namespaces} ${argocd_managedNamespaces}"

formatted_all_namespaces="\"${all_namespaces// /, }\""

echo "$formatted_all_namespaces"