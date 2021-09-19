#!/bin/bash
IP=`hostname -I |awk '{print $1}'`
yum install -y socat conntrack ebtables ipset tmux vim wget lsof net-tools openssl ipvsadm nfs-utils chrony haproxy keepalived  ntpdate
wget http://10.10.10.3/bakup/k8s-14.2/docker-19.03.tar.gz
tar xf /root/docker-19.03.tar.gz
yum localinstall /root/docker/* -y
sh /root/docker.sh
wget http://10.10.10.3/k8s1.7.9.tar.gz -P /root
tar xf /root/k8s1.7.9.tar.gz
sed -i "s/10.10.10.120/$IP/g" /root/config-sample.yaml
