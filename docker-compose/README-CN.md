
# docker compose

使用Docker Compose 运行 Univer 服务端。

- [EN](./README.md)
- [CN](./README-CN.md)

---

## Machine Requirement
1. CPU: 1核
2. 内存: 2G
3. 磁盘：10G
4. 系统: Linux, Mac

## Quick start

1. 安装 [docker >= 23 版本](https://docs.docker.com/engine/install/).

2. 克隆本仓库.
```bash
git clone https://github.com/dream-num/helm-charts.git
```

3. 进入 `docker-compose` 目录.
```bash
cd helm-charts/docker-compose
```

4. 启动服务.
```bash
bash run.sh
```

5. 可以利用我们提供的demo打开对应的表格. 
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
1. 怎么启动可观测性组件？
```
在 .env.custom 文件中设置：
ENABLE_UNIVER_OBSERVABILITY=true
```

2. 怎么解决端口冲突？
```
在 .env.custom 文件中修改端口:
HOST_NGINX_PORT=8000
HOST_MINIO_PORT=19000
HOST_GRAFANA_PORT=13000
```

3. 如果你需要服务的 sql 定义，可以从[这里获取](https://release-univer.oss-cn-shenzhen.aliyuncs.com/releases/latest/univer-server-sql-latest.tar.gz)
