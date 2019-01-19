#!/bin/bash
oldbootkubeversion="v0.14.0"
bootkubeversion="v0.14.0"
tillerversion="v2.12.2"
kuberneterversion="v1.10.1"
pauseversion="3.1"
kubernetesdashboardversion=v1.10.1
rm -rf `pwd`/bootkube$bootkubeversion/*
docker run -it -v `pwd`/bootkube$bootkubeversion/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/flannel
docker run -it -v `pwd`/bootkube$bootkubeversion/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/canal --network-provider experimental-canal
mkdir -p `pwd`/bootkube$bootkubeversion/asset/all
cp -rf `pwd`/bootkube$bootkubeversion/asset/flannel/* `pwd`/bootkube$bootkubeversion/asset/all/
cp -rf `pwd`/bootkube$bootkubeversion/asset/canal/* `pwd`/bootkube$bootkubeversion/asset/all/
listimage=$(grep -rh image: `pwd`/bootkube$bootkubeversion/asset/all  | sort | uniq | awk '{print $2}')
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
echo "FROM k8s.gcr.io/kubernetes-dashboard-amd64:$kubernetesdashboardversion" > ./bootkube$bootkubeversion/kubernetes-dashboard/Dockerfile


