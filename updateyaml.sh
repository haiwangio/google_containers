#!/bin/bash
oldbootkubeversion="v0.12.0"
bootkubeversion="v0.12.0"
rm -rf `pwd`/asset/*
docker run -it -v `pwd`/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/flannel --cloud-provider=tempcloudprovider
docker run -it -v `pwd`/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/canal --network-provider experimental-canal --cloud-provider=tempcloudprovider
mkdir -p `pwd`/asset/all
cp -rf `pwd`/asset/flannel/* `pwd`/asset/all/
cp -rf `pwd`/asset/canal/* `pwd`/asset/all/
sed -i "s/https:\/\/127.0.0.1:2379/\$\{endpoints\}/g" `find ./asset/all -type f`
sed -i "s/tempcloudprovider/\$\{cloud_provider\}/g" `find ./asset/all -type f`
sed -i "s/10.2.0.0\/16/\$\{pod_cidr\}/g" `find ./asset/all -type f`
sed -i "s/10.3.0.0\/24/\$\{service_cidr\}/g" `find ./asset/all -type f`
sed -i "s/6443/\$\{api_port\}/g" `find ./asset/all -type f`
sed -i "s/cluster.local/\$\{cluster_name\}/g" `find ./asset/all -type f`
sed -i "s/cluster.local/\$\{cluster_name\}/g" `find ./asset/all -type f`
sed -i  "s/flannel:.*$/flannel:\$\{tag\}/g" `find ./asset/all -type f`
sed -i  "s/flannel-cni:.*$/flannel-cni:\$\{tag\}/g" `find ./asset/all -type f`
sed -i  "s/\/cni:.*$/\/calico-cni:\$\{tag\}/g" `find ./asset/all -type f`
sed -i  "s/hyperkube:.*$/hyperkube:\$\{tag\}/g" `find ./asset/all -type f`
sed -i  "s/pod-checkpointer:.*$/pod-checkpointer:\$\{tag\}/g" `find ./asset/all -type f`
sed -i  "s/k8s-dns-kube-dns-amd64:.*$/k8s-dns-kube-dns-amd64:\$\{tag\}/g" `find ./asset/all -type f`
sed -i  "s/k8s-dns-dnsmasq-nanny-amd64:.*$/k8s-dns-dnsmasq-nanny-amd64:\$\{tag\}/g" `find ./asset/all -type f`
sed -i  "s/k8s-dns-sidecar-amd64:.*$/k8s-dns-sidecar-amd64:\$\{tag\}/g" `find ./asset/all -type f`
sed -i  "s/node:.*$/calico-node:\$\{tag\}/g" `find ./asset/all -type f`

sed -i  "s/quay.io\/coreos/\$\{registry\}\/\$\{namespace\}/g" `find ./asset/all -type f`
sed -i  "s/quay.io\/calico/\$\{registry\}\/\$\{namespace\}/g" `find ./asset/all -type f`
sed -i  "s/k8s.gcr.io/\$\{registry\}\/\$\{namespace\}/g" `find ./asset/all -type f`
sed -i  "s/kube-system/\$\{kube-system\}/g" `find ./asset/all -type f`
mkdir -p asset/resources/calico
mv  asset/all/manifests/calico* asset/resources/calico/
mkdir -p   asset/resources/flannel/
mv  asset/all/manifests/flannel* asset/resources/flannel/
mkdir -p asset/resources/bootstrap-manifests/
mv asset/all/bootstrap-manifests/* asset/resources/bootstrap-manifests/
mkdir -p asset/resources/manifests/
mv asset/all/manifests/* asset/resources/manifests/
















