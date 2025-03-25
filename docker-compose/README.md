
# docker compose

A temporary way to run univer servers using docker-compose.

- [EN](./README.md)
- [CN](./README-CN.md)

---

## Machine Requirement
1. CPU: 1 cores
2. Memory: 2G
3. Disk: 10G
4. OS: Linux, Mac

## Quick start

1. Install [docker >= 23.0 version](https://docs.docker.com/engine/install/).

2. Clone this repository.
```bash
git clone https://github.com/dream-num/helm-charts.git
```

3. Change directory to `docker-compose`.
```bash
cd helm-charts/docker-compose
```

4. Run docker-compose.
```bash
bash run.sh
```

5. You can use our demo to try. 
```bash
bash run.sh start-demo-ui
```

## Use port

| service   | port  | description              |
| --------- | ----- | ------------------------ |
| universer | 8000  | api http server          |
| minio     | 19000 | s3 object storage server |
| grafana   | 13000  | grafana dashboard server |

## [Q&A](https://docs.univer.ai/zh-CN/guides/sheets/pro-features/server/deploy)
1. How to enable observability component?
```
set in the .env.custom file:
ENABLE_UNIVER_OBSERVABILITY=true
```

2. How to deal with host port conflict?
```
# change the host ports in .env.custom file:
HOST_NGINX_PORT=8000
HOST_MINIO_PORT=19000
HOST_GRAFANA_PORT=13000
```

3. If you need the server sql schema, you can get from [this](https://release-univer.oss-cn-shenzhen.aliyuncs.com/releases/latest/univer-server-sql-latest.tar.gz)