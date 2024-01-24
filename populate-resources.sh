#!/bin/bash

mkdir -p "manifests"

for i in {1..100}
do
  for j in {1..5}
  do
    app_name="sample-app-$((5*(i-1) + j))"
    folder_name="manifests-$((5*(i-1) + j))"
    namespace="ns-$i"
    
    mkdir -p "$folder_name"
    
    cat <<EOF > "$folder_name/deployment.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: $app_name
  name: $app_name
  namespace: $namespace
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $app_name
  template:
    metadata:
      labels:
        app: $app_name
    spec:
      containers:
      - image: quay.io/redhatworkshops/bgd:latest
        name: $app_name
        env:
        - name: COLOR
          value: "blue"
        resources: {}
EOF

    cat <<EOF > "$folder_name/configmap.yaml"
apiVersion: v1
kind: ConfigMap
metadata:
  name: $app_name-configmap
  namespace: $namespace
  labels:
    app: $app_name
data:
  database: mongodb
  database_uri: mongodb://localhost:27017
  keys: |
    image.public.key=771
    rsa.public.key=42
EOF

    cat <<EOF > "$folder_name/statefulset.yaml"
apiVersion: apps/v1
kind: StatefulSet
metadata:
  labels:
    app: $app_name
  name: $app_name
  namespace: $namespace
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $app_name
  serviceName: $app_name
  template:
    metadata:
      labels:
        app: $app_name
    spec:
      containers:
      - image: quay.io/redhatworkshops/bgd:latest
        name: $app_name
        env:
        - name: COLOR
          value: "blue"
        resources: {}
EOF


    cat <<EOF > "$folder_name/secret.yaml"
apiVersion: v1
kind: Secret
metadata:
  name: $app_name-secret
  namespace: $namespace
  labels:
    app: $app_name
data:
EOF

#     cat <<EOF > "manifests/$folder_name/route.yaml"
# apiVersion: route.openshift.io/v1
# kind: Route
# metadata:
#   labels:
#     app: $app_name
#   name: $app_name
#   namespace: $namespace
# spec:
#   host: "PATCH_ME"
#   port:
#     targetPort: 8080
#   to:
#     kind: Service
#     name: $app_name
#     weight: 100
# status:
#   ingress:
#   - conditions:
#     - status: "True"
#       type: Admitted
# EOF

    cat <<EOF > "$folder_name/service.yaml"
apiVersion: v1
kind: Service
metadata:
  labels:
    app: $app_name
  name: $app_name
  namespace: $namespace
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: $app_name
EOF

  done
done

echo "Manifest folders and files created."
