#!/bin/bash
oldbootkubeversion="v0.14.0"
bootkubeversion="v0.14.0"
rm -rf `pwd`/asset/*
docker run -it -v `pwd`/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/flannel
docker run -it -v `pwd`/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/canal --network-provider experimental-canal
mkdir -p `pwd`/asset/all
cp -rf `pwd`/asset/flannel/* `pwd`/asset/all/
cp -rf `pwd`/asset/canal/* `pwd`/asset/all/
listimage=$(grep -rh image: `pwd`/asset/all  | sort | uniq | awk '{print $2}')
mkdir -p ./bootkube$bootkubeversion
for ilist in $listimage
do 
dockerv=$(echo $ilist | sed -s "s/:/-/g")
dockerfile=${dockerv##*/}
mkdir -p ./bootkube$bootkubeversion/$dockerfile
echo "FROM $ilist" > ./bootkube$bootkubeversion/$dockerfile/Dockerfile

done
mkdir -p ./bootkube$bootkubeversion/pause-amd64-3.1
echo "FROM k8s.gcr.io/pause-amd64:3.1" > ./bootkube$bootkubeversion/pause-amd64-3.1/Dockerfile
mkdir -p ./bootkube$bootkubeversion/ > ./bootkube$bootkubeversion/tiller/Dockerfile

echo "FROM gcr.io/kubernetes-helm/tiller:v2.9.1" > ./bootkube$bootkubeversion/tiller/Dockerfile

