# Cluster
```bash
kind create cluster --name yu-cluster --verbosity=10
kind get clusters  # List the created clusters
```

## Create Testing Environment in North Cluster

```bash
# Set the Kind cluster as the current contex
kubectl config use-context kind-yu-cluster
k create namespace yuya-test
kubectl config set-context --current --namespace=yuya-test
```
# ArgoCD 

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
k create namespace argocd
helm install argocd argo/argo-cd --namespace argocd
k get all -n argocd
k port-forward svc/argocd-server -n argocd 8080:443

# Login to ArgoCD 
# username: admin
# password:
k -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Step 3: Deploy the Application Using ArgoCD
```bash
k apply -f argocd/argocd-applicationsets.yaml
k get pod helloworld-pod
k logs helloworld-pod
# Expected Output: Hello from ArgoCD!
```