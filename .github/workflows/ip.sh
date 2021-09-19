#！/bin/bash
read -p "请出入IP（3-253）：" A
IP=10.10.10.
cat > /etc/sysconfig/network-scripts/ifcfg-ens33 << EOF
NAME=ens33
DEVICE=ens33
ONBOOT=yes
BOOTPROTO=none
IPADDR="$IP$A"
NETMASK=255.255.255.0
GATEWAY=10.10.10.2
DNS1=10.10.10.2
EOF
systemctl restart network
clear
read -p "请输入的主机名: " C
hostnamectl set-hostname $C
bash
B=`ip a |grep brd |grep inet|awk '{print $2}'|awk -F '/' '{print $1}'`
if [ $B == $IP$A ]
then
    echo "ip 配置成功"
else
    echo "ip 配置失败"
fi
