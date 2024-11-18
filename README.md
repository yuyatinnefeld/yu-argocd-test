# Cluster
```bash
kind create cluster --name yu-cluster --verbosity=10
kind get clusters  # List the created clusters
```

# Create Testing Environment in Test Cluster

```bash
# Set the Kind cluster as the current contex
kubectl config use-context kind-yu-cluster
k create namespace yuya-test
kubectl config set-context --current --namespace=yuya-test
```

# Vault
```bash
# Install Vault Server
NS_VAULT=vault
kubectl config set-context --current --namespace=$NS_VAULT
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault -n $NS_VAULT

# Install External Secrets Operator
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets external-secrets/external-secrets -n $NS_VAULT

# Wait until the vault-0 pod is ready
kubectl exec -ti vault-0 -n $NS_VAULT -- vault operator init

# Unseal Vault
kubectl config set-context --current --namespace=$NS_VAULT
kubectl port-forward vault-0 8200:8200 -n $NS_VAULT
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN_PATH_C1="kv/data/multicluster/okpd/kubeconfig"

# Upgrade KV engine from v1 to v2
vault login
vault secrets enable -version=2 kv

# Create a secret for testing in CLUSTER_1
vault secrets list
vault kv put $VAULT_TOKEN_PATH_C1 TEST_TOKEN=token-cluster-test

# Create secret for the secret store to access vault
export VAULT_K8S_USER_NAME=cluster-user
export VAULT_K8S_USER_PWD=super-pwd
vault policy write admin-policy admin.hcl
vault auth enable userpass
vault write auth/userpass/users/$VAULT_K8S_USER_NAME password=$VAULT_K8S_USER_PWD policies=admin-policy
vault login -method=userpass username=$VAULT_K8S_USER_NAME
export VAULT_K8S_USER_TOKEN=hvs.xxxx
export VAULT_K8S_USER_TOKEN_NAME=vault-k8s-token
kubectl create secret -n $NS_VAULT generic $VAULT_K8S_USER_TOKEN_NAME --from-literal=token=$VAULT_K8S_USER_TOKEN

# Deploy SecretStore
kubectl apply -f vault/depl-secretstore.yaml

# Check Status
kubectl get secretstore -n vault
```

# ArgoCD 
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
k create namespace argocd
helm install argocd argo/argo-cd --namespace argocd
k get all -n argocd
k port-forward svc/argocd-server -n argocd 8080:443

# username: admin, password:
k -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
k apply -f argocd/argocd-application-set.yaml
```