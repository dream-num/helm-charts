#!/bin/bash

if [! helm version] &> /dev/null; then
    echo "need helm."
    exit 1
fi

kube_conf=""
if [ "$KUBECONFIG" != "" ]; then
    kube_conf="--kubeconfig $KUBECONFIG"
fi

na=""
if [ "$NAMESPACE" != "" ]; then
    na="-n $NAMESPACE"
fi

if [ $UNIVER_DELETE ]; then
    helm $kube_conf $na uninstall postgresql
    helm $kube_conf $na uninstall rabbitmq
    helm $kube_conf $na uninstall collaboration-server
    helm $kube_conf $na uninstall universer
    helm $kube_conf $na uninstall loki-stack
else
    helm $kube_conf upgrade --install $na --create-namespace --values charts-value/postgresql.yaml postgresql charts/postgresql
    helm $kube_conf upgrade --install $na --create-namespace --values charts-value/rabbitmq.yaml rabbitmq charts/rabbitmq
    helm $kube_conf upgrade --install $na --create-namespace --values charts-value/collaboration-server.yaml collaboration-server charts/collaboration-server
    helm $kube_conf upgrade --install $na --create-namespace --values charts-value/universer.yaml \
        --set-file license.LICENSE=./configs/LICENSE \
        --set-file license.publicKey=./configs/public_key.crt \
        universer charts/universer
    helm $kube_conf upgrade --install $na --create-namespace --values charts-value/loki-stack.yaml loki-stack charts/loki-stack
fi
