# MultiMesh Cluster Comminication Chart

## Execute Chart
```bash
cd lab1-cluster
helm install multimesh-cluster-communication-charts . -f values-env-lab1.yaml --dry-run
```

## Check SA
```bash
oc get sa | grep to-access
```

## Check OpenShift Secrets
```bash
oc get secret | grep kubeconfig
```

## Check PushSecrets

```bash
oc get ss vault -oyaml
oc get pushsecret
oc get pushsecret pushsecret-vault-all-secrets-mc-okpc-to-access-kubeconfig -o yaml
```

## Check PullSecrets

```bash
oc get externalsecret 
oc get externalsecret pullsecret-vault-all-secrets-access -o yaml
oc get secret istio-remote-secret-access-cluster
```