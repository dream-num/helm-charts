#!/bin/bash

NAMESPACE="univer"

CHART=$(ls univer-stack-*.tgz | tail -n 1)

helm upgrade --install -n $NAMESPACE --create-namespace \
    --set global.istioNamespace="$NAMESPACE" \
    --values values.yaml \
    univer-stack ./$CHART

kubectl rollout restart -n $NAMESPACE deployment/collaboration-server
kubectl rollout restart -n $NAMESPACE deployment/universer
