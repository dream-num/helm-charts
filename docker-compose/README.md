
# docker compose

A temporary way to run univer servers using docker-compose. This is not intended for production use.

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

## [Q&A](https://www.univer.ai/pro/enterprises/trial-version/)
1. How to deal "Save as" error？
```
Replace localhost with the local IP for S3_ENDPOINT_PUBLIC config in .env file, it make people can use Download as in local area network.

# Example: S3_ENDPOINT_PUBLIC=http://127.0.0.1:9000
# Replace to: S3_ENDPOINT_PUBLIC=http://192.168.50.172:19000
```

2. How to enable observability compoment?
```
uncomment the following line in .env file:
# COMPOSE_PROFILES=observability
```

3. How to deal with host port conflict?
```
# change the host ports in .env file:
HOST_NGINX_PORT=8000
HOST_MINIO_PORT=19000
HOST_GRAFANA_PORT=13000
```