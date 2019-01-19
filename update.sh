#!/bin/bash
oldbootkubeversion="v0.14.0"
bootkubeversion="v0.14.0"
tillerversion="v2.12.2"
kuberneterversion="v1.10.1"
pauseversion="3.1"
rm -rf `pwd`/asset/*
docker run -it -v `pwd`/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/flannel
docker run -it -v `pwd`/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/canal --network-provider experimental-canal
mkdir -p `pwd`/asset/all
cp -rf `pwd`/asset/flannel/* `pwd`/asset/all/
cp -rf `pwd`/asset/canal/* `pwd`/asset/all/
listimage=$(grep -rh image: `pwd`/asset/all  | sort | uniq | awk '{print $2}')
rm -rf ./bootkube$bootkubeversion
mkdir -p ./bootkube$bootkubeversion
for ilist in $listimage
do 
dockerv=$(echo $ilist | sed -s "s/:/-/g")
dockerfile=${dockerv##*/}
mkdir -p ./bootkube$bootkubeversion/$dockerfile
echo "FROM $ilist" > ./bootkube$bootkubeversion/$dockerfile/Dockerfile

done
mkdir -p ./bootkube$bootkubeversion/pause
echo "FROM k8s.gcr.io/pause-amd64:$pauseversion" > ./bootkube$bootkubeversion/pause/Dockerfile
mkdir -p ./bootkube$bootkubeversion/tiller 
echo "FROM gcr.io/kubernetes-helm/tiller:$tillerversion" > ./bootkube$bootkubeversion/tiller/Dockerfile
mkdir -p ./bootkube$bootkubeversion/kubernetes-dashboard
echo "FROM k8s.gcr.io/kubernetes-dashboard-amd64:$kubernetesversion" > ./bootkube$bootkubeversion/kubernetes-dashboard/Dockerfile


