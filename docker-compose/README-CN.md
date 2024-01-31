
# docker compose

使用Docker Compose 运行 Univer 服务端, 此方法不适用于生产环境。

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
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:latest
               
docker run --net=unvier-prod --rm --name univer-collaboration-lite \
  -p 3010:3010 \
  univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-lite:latest

# Open URL: http://localhost:3010
```

## Use port

| service            | port | description             |
| ------------------ | ---- | ----------------------- |
| universer          | 8000 | api http server         |
