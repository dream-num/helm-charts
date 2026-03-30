#!/bin/bash

chartsFolder=${1:-./../../../charts}

ls $chartsFolder

YQ=mikefarah/yq:4
# YQ=univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/release/yq:4

UNIVERSER_VERSION=$(cat $chartsFolder/universer/values.yaml | docker run --rm -i $YQ e '.image.tag' -)
UNIVERSER_SQL_VERSION=$(cat $chartsFolder/universer/values.yaml | docker run --rm -i $YQ e '.job.image.tag' -)
UNIVER_COLLABORATION_VERSION=$(cat $chartsFolder/collaboration-server/values.yaml | docker run --rm -i $YQ e '.image.tag' -)
UNIVER_COLLABORATION_LITE_VERSION=$(cat $chartsFolder/collaboration-demo/values.yaml | docker run --rm -i $YQ e '.image.tag' -)
UNIVER_WORKER_EXCHANGE_VERSION=$(cat $chartsFolder/univer-stack/values.yaml | docker run --rm -i $YQ e '.worker.image.tag' -)

echo "UNIVERSER_VERSION: $UNIVERSER_VERSION"

sed -i -e 's/${UNIVERSER_VERSION}/'${UNIVERSER_VERSION}'/g' image-list.sh
sed -i 's/${UNIVERSER_SQL_VERSION}/'${UNIVERSER_SQL_VERSION}'/g' image-list.sh
sed -i 's/${UNIVER_COLLABORATION_VERSION}/'${UNIVER_COLLABORATION_VERSION}'/g' image-list.sh
sed -i 's/${UNIVER_COLLABORATION_LITE_VERSION}/'${UNIVER_COLLABORATION_LITE_VERSION}'/g' image-list.sh
sed -i 's/${UNIVER_WORKER_EXCHANGE_VERSION}/'${UNIVER_WORKER_EXCHANGE_VERSION}'/g' image-list.sh

cat image-list.sh

. ./image-list.sh

pull_with_retry() {
    local image=$1
    local max_retries=5
    local retry_delay=10
    local attempt=1

    while [[ $attempt -le $max_retries ]]; do
        echo "Pulling $image (attempt $attempt/$max_retries)..."
        docker pull "$image" && return 0

        if [[ $attempt -lt $max_retries ]]; then
            echo "Failed to pull $image, retrying in ${retry_delay}s..."
            sleep $retry_delay
        fi

        ((attempt++))
    done

    echo "Failed to pull image after $max_retries attempts: $image"
    return 1
}

# pull univer service images
for image in "${images[@]}"; do
    pull_with_retry "$image" || exit 1
done

# pull observability images
for image in "${observability_images[@]}"; do
    pull_with_retry "$image" || exit 1
done

docker save "${images[@]}" | gzip > univer-image.tar.gz

docker save "${observability_images[@]}" | gzip > observability-image.tar.gz

helm pull oci://univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/helm-charts/univer-stack --destination .

helm pull oci://univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/helm-charts/univer-observability --destination .

chart=$(ls univer-stack-*.tgz | head -n 1)
version=$(echo "$chart" | sed -n 's/univer-stack-\(.*\).tgz/\1/p')

tar -cvf k8s-all-in-one.${version}.tar \
    univer-image.tar.gz \
    $chart \
    univer-observability-*.tgz \
    image-list.sh load-image.sh

echo "ALLINONE_PATH=$(echo $PWD/k8s-all-in-one.${version}.tar)" >> $GITHUB_ENV
echo "ALLINONE_TAR=$(echo k8s-all-in-one.${version}.tar)" >> $GITHUB_ENV