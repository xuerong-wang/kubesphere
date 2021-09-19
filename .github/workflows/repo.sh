#!/bin/bash
setenforce 0
mkdir /bak
mv /etc/yum.repos.d/* /bak
cat > /etc/yum.repos.d/1.repo << EOF
[i]
name=i
baseurl=http://10.10.10.3
enable=1
gpgcheck=0
[o]
name=o
baseurl=http://10.10.10.3/kubesphere
enable=1
gpgcheck=0
EOF
yum makecache
echo "配置源文件完毕"
