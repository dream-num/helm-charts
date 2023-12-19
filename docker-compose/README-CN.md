
# docker compose

使用Docker Compose 运行通用服务器的临时方法。此方法不适用于生产环境。

- [EN](./README.md)
- [CN](./README-CN.md)

---

## Machine Requirement
1. CPU: 2核
2. 内存: 4G
3. 磁盘：50G
4. 系统: Linux, Mac

## Quick start

1. 安装 [docker](https://docs.docker.com/install/) 和 [docker-compose](https://docs.docker.com/compose/install/).

2. 克隆本仓库.
```bash
git clone https://github.com/dream-num/helm-charts.git
```

3. 进入 `docker-compose` 目录.
```bash
cd helm-charts/docker-compose
```

1. 将 `LICENSE` 和 `public_key.crt` 文件放到./configs目录下（激活文件可以发邮件到 `developer@univer.ai` 或者官方微信联系获取）. 
```bash
vim ./configs/LICENSE 
vim ./configs/public_key.crt

Copy the contents of the email

eg LICENSE:
-----BEGIN LICENSE KEY-----
xxxxx
-----END LICENSE KEY-----

eg public_key.crt:
-----BEGIN RSA PUBLIC KEY-----
xxxxx
-----END RSA PUBLIC KEY-----
```

5. 启动服务.
```bash
bash run.sh
```

6. 创建一个试用表格.
```bash
curl -i -X 'POST' \
  'http://localhost:8000/universer-api/snapshot/2/unit/-/create' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "type": 2,
    "name": "New Sheet - 12/13",
    "creator": "user",
    "workbookMeta": {
        "name": "New Sheet - 12/13",
        "locale": "en_US"
    }
}'

# response: 
# {"error":{"code":"OK","message":"success"},"unitID":"1735864608675115008"}
```

7. 可以利用我们提供的demo打开对应的表格. 
```bash
docker pull univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-demo:latest

docker run -it -d \
  -p 3010:3010 \
  univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/univer-collaboration-demo:latest

# Open URL: http://localhost:3010?unit=${unitID}&type=2
```

## Use port

| service            | port | description             |
| ------------------ | ---- | ----------------------- |
| universer          | 8000 | api http server         |
