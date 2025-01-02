#!/bin/sh

REGISTRY=""
IMAGE_NAMESPACE=""

# check docker command
if ! command -v docker &> /dev/null; then
    echo "docker command not found"
    exit 1
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --registry)
            REGISTRY="$2"
            ;;
        --namespace)
            IMAGE_NAMESPACE="$2"
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift 2
done

IMAGE_NAMESPACE=${IMAGE_NAMESPACE:-"release"}

echo "REGISTRY: $REGISTRY"
echo "IMAGE_NAMESPACE: $IMAGE_NAMESPACE"

if [ -z "$REGISTRY" ]; then
    echo "Please specify the registry"
    exit 1
fi

. ./image-list.sh

docker load -i univer-image.tar.gz

for image in "${images[@]}"; do
    docker tag $image $REGISTRY/$IMAGE_NAMESPACE/$(basename $image)
    docker push $REGISTRY/$IMAGE_NAMESPACE/$(basename $image)
done

docker load -i observability-image.tar.gz

for image in "${observability_images[@]}"; do
    docker tag $image $REGISTRY/$IMAGE_NAMESPACE/$(basename $image)
    docker push $REGISTRY/$IMAGE_NAMESPACE/$(basename $image)
done

SED="sed -i"
if [ "$(uname)" == "Darwin" ]; then
    SED="sed -i \"\""
fi

$SED -e 's#${REGISTRY}#'${REGISTRY}'#' values.yaml
$SED -e 's#${IMAGE_NAMESPACE}#'${IMAGE_NAMESPACE}'#' values.yaml

$SED -e 's#${REGISTRY}#'${REGISTRY}'#' values-observability.yaml
$SED -e 's#${IMAGE_NAMESPACE}#'${IMAGE_NAMESPACE}'#' values-observability.yaml
