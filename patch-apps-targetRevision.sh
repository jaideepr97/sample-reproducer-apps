#!/bin/bash

ARGOCD_NAMESPACE="project-gitops"

APP_PREFIX="sample-app-"

TARGET_REVISION="alt-main"

# Get the list of ArgoCD applications that start with the specified app prefix
APP_LIST=$(oc get applications -n $ARGOCD_NAMESPACE --output=json | jq -r '.items[] | select(.metadata.name | startswith("'$APP_PREFIX'")) | .metadata.name')
echo $APP_LIST

# Iterate over eac of the APP_LIST applications and patch them with the new TARGET_REVISION branch
for APP_NAME in $APP_LIST; do
    echo "Patching application: $APP_NAME"
    oc patch app $APP_NAME -n $ARGOCD_NAMESPACE --type='json' -p='[{"op": "replace", "path": "/spec/source/targetRevision", "value": "'$TARGET_REVISION'"}]'
done