
# docker compose

A temporary way to run univer servers using docker-compose. This is not intended for production use.

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

4. Put `LICENSE` and `public_key.crt` file to ./configs folder.
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

7. Open the web page to try Univer. `http://localhost:3010?unit=${unitID}&type=2`

## Use port

| service            | port | description             |
| ------------------ | ---- | ----------------------- |
| universer          | 8000 | api http server         |
| collaboration-demo | 3010 | demo http server        |
| grafana            | 3000 | use to query server log |
