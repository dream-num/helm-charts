
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

1. Install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/).

2. Clone this repository.
```bash
git clone https://github.com/dream-num/helm-charts.git
```

3. Change directory to `docker-compose`.
```bash
cd helm-charts/docker-compose
```

4. Ask `developer@univer.ai` or [Discord](https://discord.gg/z3NKNT6D2f) for get `LICENSE` and `public_key.crt` file to try out.

5. Put `LICENSE` and `public_key.crt` file to ./configs folder.

6. Run docker-compose.
```bash
bash run.sh
```

7. Create a demo sheet.
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

8. You can use our demo to try. 
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
