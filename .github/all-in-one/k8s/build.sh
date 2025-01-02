#!/bin/bash

chartsFolder=${1:-./../../../charts}

ls $chartsFolder

UNIVERSER_VERSION=$(docker run --rm -v $chartsFolder/universer/:/tmp/ mikefarah/yq:4 e '.image.tag' /tmp/values.yaml)
UNIVERSER_SQL_VERSION=$(docker run --rm -v $chartsFolder/universer/:/tmp/ mikefarah/yq:4 e '.job.image.tag' /tmp/values.yaml)
UNIVER_COLLABORATION_VERSION=$(docker run --rm -v $chartsFolder/collaboration-server/:/tmp/ mikefarah/yq:4 e '.image.tag' /tmp/values.yaml)
UNIVER_COLLABORATION_LITE_VERSION=$(docker run --rm -v $chartsFolder/collaboration-demo/:/tmp/ mikefarah/yq:4 e '.image.tag' /tmp/values.yaml)
UNIVER_WORKER_EXCHANGE_VERSION=$(docker run --rm -v $chartsFolder/univer-stack/:/tmp/ mikefarah/yq:4 e '.worker.image.tag' /tmp/values.yaml)

echo "UNIVERSER_VERSION: $UNIVERSER_VERSION"

sed -i -e 's/${UNIVERSER_VERSION}/'${UNIVERSER_VERSION}'/g' image-list.sh
sed -i 's/${UNIVERSER_SQL_VERSION}/'${UNIVERSER_SQL_VERSION}'/g' image-list.sh
sed -i 's/${UNIVER_COLLABORATION_VERSION}/'${UNIVER_COLLABORATION_VERSION}'/g' image-list.sh
sed -i 's/${UNIVER_COLLABORATION_LITE_VERSION}/'${UNIVER_COLLABORATION_LITE_VERSION}'/g' image-list.sh
sed -i 's/${UNIVER_WORKER_EXCHANGE_VERSION}/'${UNIVER_WORKER_EXCHANGE_VERSION}'/g' image-list.sh

cat image-list.sh

. ./image-list.sh

# pull univer service images
for image in "${images[@]}"; do
    docker pull $image
done

# pull observability images
for image in "${observability_images[@]}"; do
    docker pull $image
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
    image-list.sh install.sh load-image.sh uninstall.sh

echo "ALLINONE_PATH=$(echo $PWD/k8s-all-in-one.${version}.tar)" >> $GITHUB_ENV
echo "ALLINONE_TAR=$(echo k8s-all-in-one.${version}.tar)" >> $GITHUB_ENV