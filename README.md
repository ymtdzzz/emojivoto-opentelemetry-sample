# emojivoto-opentelemetry-sample
## Getting Started
### Deploy jaeger to your kubernetes cluster
- `minikube start`

- deploy jaeger-operator

```sh
# create ns
kubectl create ns observability

# deploy jaeger-operator
helm repo add jetstack https://charts.jetstack.io
helm repo add jaegertracing https://jaegertracing.github.io/helm-chartshelm repo add jaegertracing https://jaegertracing.github.io/helm-chartshelm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
helm install \
	  cert-manager jetstack/cert-manager \
	  --namespace cert-manager \
	  --create-namespace \
	  --version v1.8.2 \
	  --set installCRDs=true
helm install jaeger-operator jaegertracing/jaeger-operator -n observability --set rbac.clusterRole=true
```

- deploy jaeger

```
kubectl apply -f kubernetes/jaeger
```

- deploy emoji backend and vote-bot

```
kubectl apply -f kubernetes/emojivoto/ns.yaml
kubectl apply -f kubernetes/emojivoto
```
