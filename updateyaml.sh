#!/bin/bash
oldbootkubeversion="v0.14.0"
bootkubeversion="v0.14.0"
rm -rf `pwd`/bootkube$bootkubeversion/asset/*
docker run -it -v `pwd`/bootkube$bootkubeversion/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render   --asset-dir=/asset/flannel --cloud-provider=tempcloudprovider
docker run -it -v `pwd`/bootkube$bootkubeversion/asset:/asset quay.io/coreos/bootkube:${bootkubeversion} /bootkube  render --asset-dir=/asset/canal --network-provider experimental-canal --cloud-provider=tempcloudprovider 
mkdir -p `pwd`/bootkube$bootkubeversion/asset/all
cp -rf `pwd`/bootkube$bootkubeversion/asset/flannel/* `pwd`/bootkube$bootkubeversion/asset/all/
cp -rf `pwd`/bootkube$bootkubeversion/asset/canal/* `pwd`/bootkube$bootkubeversion/asset/all/
sed -i "s/https:\/\/127.0.0.1:2379/\$\{endpoints\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i "s/tempcloudprovider/\$\{cloud_provider\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i "s/10.2.0.0\/16/\$\{pod_cidr\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i "s/10.3.0.0\/24/\$\{service_cidr\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i "s/6443/\$\{api_port\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i "s/cluster.local/\$\{cluster_name\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i "s/cluster.local/\$\{cluster_name\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/flannel:.*$/flannel:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/flannel-cni:.*$/flannel-cni:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/\/cni:.*$/\/calico-cni:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/hyperkube:.*$/hyperkube:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/pod-checkpointer:.*$/pod-checkpointer:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/k8s-dns-kube-dns-amd64:.*$/k8s-dns-kube-dns-amd64:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/k8s-dns-dnsmasq-nanny-amd64:.*$/k8s-dns-dnsmasq-nanny-amd64:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/k8s-dns-sidecar-amd64:.*$/k8s-dns-sidecar-amd64:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/node:.*$/calico-node:\$\{tag\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`

sed -i  "s/quay.io\/coreos/\$\{registry\}\/\$\{namespace\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/quay.io\/calico/\$\{registry\}\/\$\{namespace\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/k8s.gcr.io/\$\{registry\}\/\$\{namespace\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
sed -i  "s/kube-system/\$\{kube-system\}/g" `find ./bootkube$bootkubeversion/asset/all -type f`
mkdir -p bootkube$bootkubeversion/asset/resources/calico
mv  bootkube$bootkubeversion/asset/all/manifests/calico* bootkube$bootkubeversion/asset/resources/calico/
mkdir -p   bootkube$bootkubeversion/asset/resources/flannel/
mv  bootkube$bootkubeversion/asset/all/manifests/flannel* bootkube$bootkubeversion/asset/resources/flannel/
mkdir -p bootkube$bootkubeversion/asset/resources/bootstrap-manifests/
mv bootkube$bootkubeversion/asset/all/bootstrap-manifests/* bootkube$bootkubeversion/asset/resources/bootstrap-manifests/
mkdir -p bootkube$bootkubeversion/asset/resources/manifests/
mv bootkube$bootkubeversion/asset/all/manifests/* bootkube$bootkubeversion/asset/resources/manifests/
















