This is a repo that contains sample apps for the sake of performance testing Argo CD instances. It contains 500 application repos containing 5 resources each. There are scripts that create 100 managed namespaces as well as create and apply the applications across those namespaces on the cluster


1. Install OpenShift GitOps operator
2. Create "project-gitops" ns
3. Create namespace scoped Argo CD instnace in "project-gitops" ns
4. Run `create-ns.sh`
5. Run `apply-apps.sh`
6. wait for apps to become sync'd and healthy 
