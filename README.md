
# Helm charts

The univer server deploy use in k8s and docker compose.

- [EN](./README.md)
- [CN](./README-CN.md)



## Install by docker compose

[Readme](./docker-compose/README.md)


## Install by k8s

1. Install [helm](https://helm.sh/docs/intro/install/).

2. Delpoy service.
```bash
helm install -n univer --create-namespace \
    --set global.istioNamespace="univer" \
    univer-stack oci://univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/helm-charts/univer-stack

kubectl rollout restart -n univer deployment/collaboration-server
kubectl rollout restart -n univer deployment/universer
```

3. Set dns resolve to try demo.
```bash
# you can edit your local hosts file to simple resolve dns.
# default domain is: univer.example.com

open: http://univer.example.com
```