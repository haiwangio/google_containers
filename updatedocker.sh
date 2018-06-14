#!/bin/bash
docker pull haiwangio/bootkube -a
listimage=$(docker images | grep  haiwangio/bootkube | awk '{ print $2 }')
for ilist in $listimage
do 
dockerv=$(echo $ilist | sed -s "s/-v0.12.0//g")
mkdir -p ./bootkubedocker/$dockerv
echo "FROM haiwangio/bootkube:$ilist" > ./bootkubedocker/$dockerv/Dockerfile

done

