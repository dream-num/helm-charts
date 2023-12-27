
# Helm charts

A collection of helm charts for various applications. Use for reference or install using helm.


## Install by docker compose

[Readme](./docker-compose/README.md)


## Install by k8s

1. Install [helm](https://helm.sh/docs/intro/install/).

2. Clone this repository.
```bash
git clone https://github.com/dream-num/helm-charts.git
```

3. Ask `developer@univer.ai` or [Discord](https://discord.gg/z3NKNT6D2f) for get `LICENSE` and `public_key.crt` file to try out.

4. Put `LICENSE` and `public_key.crt` file to ./configs folder.
   
5. Run install charts.
```bash
helm install -n univer collaboration-server charts/collaboration-server --create-namespace 

helm install -n univer \
    --set-file license.LICENSE=./configs/LICENSE \
    --set-file license.publicKey=./configs/public_key.crt \
    --set-json 'config.postgresql={"host":"postgresql","port":5432,"database":"univer","username":"postgres","password":"postgres"}' \
    --set-json 'config.rabbitmq={"host":"rabbitmq","port":5672,"username":"guest","password":"guest"}' \
    universer charts/universer --create-namespace
```