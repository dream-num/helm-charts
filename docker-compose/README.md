
# docker compose

A temporary way to run univer servers using docker-compose. This is not intended for production use.

- [EN](./README.md)
- [CN](./README-CN.md)

---

## Machine Requirement
1. CPU: 2 cores
2. Memory: 4G
3. Disk: 50G
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

4. Put `LICENSE` and `public_key.crt` file to ./configs folder (ask `developer@univer.ai` or [Discord](https://discord.gg/z3NKNT6D2f) for get it to try out).
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

5. Run docker-compose.
```bash
bash run.sh
```

6. Create a demo sheet.
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

7. You can use our demo to try. 
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
