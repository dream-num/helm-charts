# Third part charts

Install base compoment by open source helm charts for univer server if you need it.

## Install

- [postgresql](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/README.md)

```bash
helm install postgresql oci://registry-1.docker.io/bitnamicharts/postgresql
```

- [rabbitmq](https://github.com/bitnami/charts/blob/main/bitnami/rabbitmq/README.md)

```bash
helm install rabbitmq oci://registry-1.docker.io/bitnamicharts/rabbitmq
```

- [loki-stack](https://github.com/grafana/helm-charts/blob/main/charts/loki-stack/README.md)

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki-stack
```