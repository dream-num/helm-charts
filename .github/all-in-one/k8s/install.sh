#!/bin/bash

CUSTOM_VALUES_ARGS=""

while [ $# -gt 0 ]; do
    case "$1" in
        --values|-f)
            CUSTOM_VALUES_ARGS="--values $2"
            ;;
        --help|-h)
            echo "Deploy the Univer stack to a Kubernetes cluster."
            echo ""
            echo "Usage: ./install.sh [--values|-f <values-file>]"
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift 2
done

NAMESPACE="univer"

CHART=$(ls univer-stack-*.tgz | tail -n 1)

helm upgrade --install -n $NAMESPACE --create-namespace \
    --set global.istioNamespace="$NAMESPACE" \
    --values values.yaml $CUSTOM_VALUES_ARGS \
    univer-stack ./$CHART

kubectl rollout restart -n $NAMESPACE deployment/collaboration-server
kubectl rollout restart -n $NAMESPACE deployment/universer
