
# Helm charts

Univer 服务的 k8s 和 docker compose 部署方法。

- [EN](./README.md)
- [CN](./README-CN.md)


## Docker compose 版本

[Readme](./docker-compose/README-CN.md)


## K8s 版本

1. 安装 [helm](https://helm.sh/docs/intro/install/).

2. 部署服务.
```bash
helm install -n univer --create-namespace \
    --set global.istioNamespace="univer" \
    univer-stack oci://univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/helm-charts/univer-stack

kubectl rollout restart -n univer deployment/collaboration-server
kubectl rollout restart -n univer deployment/universer
```

3. 解析 DNS 并开始试用.
```bash
# 可以简单修改本地 hosts 文件来解析域名。
# 默认域名: univer.example.com

open: http://univer.example.com
```