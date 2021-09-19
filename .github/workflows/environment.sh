#!/bin/bash
setenforce 0
sed -i s/enforcing/disabled/g /etc/selinux/config
systemctl stop firewalld
systemctl disbale firewalld
swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab
yum install -y socat conntrack ebtables ipset tmux vim wget lsof net-tools openssl ipvsadm nfs-utils chrony haproxy keepalived  ntpdate
wget http://10.10.10.3/bakup/k8s-14.2/docker-19.03.tar.gz
tar xf /root/docker-19.03.tar.gz
yum localinstall /root/docker/* -y
cat > /root/docker.sh << EOF
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "log-opts": {"max-size": "100m", "max-file":"1"},
  "registry-mirrors":["http://10.10.10.114"],
  "insecure-registries":["10.10.10.114"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart dockersh /root/docker.sh
docker login 10.10.10.114 --username admin --password qwe
rm -rf /root/docker/
rm -rf /root/docker-19.03.tar.gz
