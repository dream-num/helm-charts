#!/bin/bash

. ./image-list.sh

for image in "${images[@]}"; do
    docker pull $image
done

docker save "${images[@]}" | gzip > univer-image.tar.gz

helm pull oci://univer-acr-registry.cn-shenzhen.cr.aliyuncs.com/helm-charts/univer-stack --destination .

chart=$(ls univer-stack-*.tgz | head -n 1)
version=$(echo "$chart" | sed -n 's/univer-stack-\(.*\).tgz/\1/p')

tar -cvf k8s-all-in-one.${version}.tar univer-image.tar.gz $chart image-list.sh install.sh load-image.sh uninstall.sh

echo "ALLINONE_PATH=$(echo $PWD/k8s-all-in-one.${version}.tar)" >> $GITHUB_ENV
echo "ALLINONE_TAR=$(echo k8s-all-in-one.${version}.tar)" >> $GITHUB_ENV