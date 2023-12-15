
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

## Use port

| service            | port | description             |
| ------------------ | ---- | ----------------------- |
| universer          | 8000 | api http server         |
| collaboration-demo | 3010 | demo http server        |
| grafana            | 3000 | use to query server log |
