#!/bin/bash
k8s_a=192.168.122.138
k8s_b=192.168.122.139
k8s_c=192.168.122.140
k8s_d=192.168.122.141
k8s_e=192.168.122.142
k8s_f=192.168.122.143     

install_k8s_a()
{      
      ssh $k8s_a "setenforce 0
      sed -i s/enforcing/disabled/g /etc/selinux/config
      systemctl stop firewalld
      systemctl disable firewalld
      swapoff -a
      sed -i 's/.*swap.*/#&/' /etc/fstab
      timedatectl set-timezone Asia/Shanghai
      yum install nfs-util bind -y
      yum install rpcbind -y
      wget -P /etc/sysconfig/modules/ http://10.10.10.3/bakup/k8s-14.2/conf/ipvs.modules
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      wget -P /etc/sysctl.d/ http://10.10.10.3/bakup/k8s-14.2/conf/k8s.conf
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      wget http://10.10.10.3/bakup/k8s-14.2/docker-ce-18.09.tar.gz
      tar xf /root/docker-ce-18.09.tar.gz
      yum localinstall /root/docker/* -y
      yum install yum-utils
      yum install -y bind-utils
      echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
      yum install net-snmp-libs-5.7.2-43.el7.x86_64 -y
      yum install -y keepalived
      rm -rf /etc/keepalived/keepalived.conf
      wget http://10.10.10.3/bakup/k8s-14.2/conf/master1/keepalived.conf -P /etc/keepalived/
      wget http://10.10.10.3:/bakup/k8s-14.2/keepalived.service -P /usr/lib/systemd/system/
      systemctl start keeplived
      systemctl enable keepalived
      yum install rpcbind -y
      yum install nfs-utils rpc-bind -y
      systemctl start rpcbind
      systemctl enable rpcbind
      systemctl enable nfs-server
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      yum install yum-utils -y
      wget http://10.10.10.3:/bakup/k8s-14.2/docker-repo.sh
      sh /root/docker-repo.sh
      docker version
      ip address show ens33
      wget http://10.10.10.3:/bakup/k8s-14.2/check_haproxy.sh
      yum install -y haproxy
      rm -rf /etc/haproxy/haproxy.cfg
      wget  http://10.10.10.3:/bakup/k8s-14.2/haproxy.cfg -P /etc/haproxy/
      systemctl enable haproxy
      systemctl start haproxy
      ss -lnt | grep 16443
      rm -rf /etc/hosts
      wget http://10.10.10.3/bakup/k8s-14.2/hosts -P /etc/
      docker login -u admin -p qwe harbor.cn
      wget http://10.10.10.3:/bakup/k8s-14.2/unzip/kubectl-install.tar.gz
      wget http://10.10.10.3:/bakup/k8s-14.2/install-k8s.sh
      tar xf /root/kubectl-install.tar.gz
      cd /root/kubectl-install/
      yum localinstall /root/kubectl-install/kubelet/* -y
      yum localinstall /root/kubectl-install/kubectl/* -y
      yum localinstall /root/kubectl-install/kubeadm/* -y
      systemctl enable kubelet
      systemctl start kubelet
      systemctl stop keepalived
      systemctl start keepalived
      systemctl restart haproxy
      mkdir -p /etc/kubernetes/pki/etcd
      cd /root/kubectl-install/
      kubeadm init --config=kubeadm-config.yaml --experimental-upload-certs
      sleep +1m
      mkdir -p \$HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config
      sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config
      kubectl apply -f kube-flannel.yml
      "
}

install_k8s_b()
{      
      ssh $k8s_b "setenforce 0
      sed -i s/enforcing/disabled/g /etc/selinux/config
      systemctl stop firewalld
      systemctl disable firewalld
      swapoff -a
      sed -i 's/.*swap.*/#&/' /etc/fstab
      timedatectl set-timezone Asia/Shanghai
      yum install nfs-util bind -y
      yum install rpcbind -y
      wget -P /etc/sysconfig/modules/ http://10.10.10.3/bakup/k8s-14.2/conf/ipvs.modules
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      wget -P /etc/sysctl.d/ http://10.10.10.3/bakup/k8s-14.2/conf/k8s.conf
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      wget http://10.10.10.3/bakup/k8s-14.2/docker-ce-18.09.tar.gz
      tar xf /root/docker-ce-18.09.tar.gz
      yum localinstall /root/docker/* -y
      yum install yum-utils
      yum install -y bind-utils
      echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
      yum install net-snmp-libs-5.7.2-43.el7.x86_64 -y
      yum install -y keepalived
      rm -rf /etc/keepalived/keepalived.conf
      wget http://10.10.10.3/bakup/k8s-14.2/conf/master2/keepalived.conf -P /etc/keepalived/
      wget http://10.10.10.3:/bakup/k8s-14.2/keepalived.service -P /usr/lib/systemd/system/
      systemctl start keeplived
      systemctl enable keepalived
      yum install rpcbind -y
      yum install nfs-utils rpc-bind -y
      systemctl start rpcbind
      systemctl enable rpcbind
      systemctl enable nfs-server
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      yum install yum-utils -y
      wget http://10.10.10.3:/bakup/k8s-14.2/docker-repo.sh
      sh /root/docker-repo.sh
      docker version
      ip address show ens33
      wget http://10.10.10.3:/bakup/k8s-14.2/check_haproxy.sh
      yum install -y haproxy
      rm -rf /etc/haproxy/haproxy.cfg
      wget  http://10.10.10.3:/bakup/k8s-14.2/haproxy.cfg -P /etc/haproxy/
      systemctl enable haproxy
      systemctl start haproxy
      ss -lnt | grep 16443
      rm -rf /etc/hosts
      wget http://10.10.10.3/bakup/k8s-14.2/hosts -P /etc/
      docker login -u admin -p qwe harbor.cn
      wget http://10.10.10.3:/bakup/k8s-14.2/unzip/kubectl-install.tar.gz
      wget http://10.10.10.3:/bakup/k8s-14.2/install-k8s.sh
      tar xf /root/kubectl-install.tar.gz
      cd /root/kubectl-install/
      yum localinstall /root/kubectl-install/kubelet/* -y
      yum localinstall /root/kubectl-install/kubectl/* -y
      yum localinstall /root/kubectl-install/kubeadm/* -y
      systemctl enable kubelet
      systemctl start kubelet
      systemctl stop keepalived
      systemctl start keepalived
      systemctl restart haproxy
      mkdir -p /etc/kubernetes/pki/etcd
      "
}


install_k8s_c()
{      
      ssh $k8s_c "setenforce 0
      sed -i s/enforcing/disabled/g /etc/selinux/config
      systemctl stop firewalld
      systemctl disable firewalld
      swapoff -a
      sed -i 's/.*swap.*/#&/' /etc/fstab
      timedatectl set-timezone Asia/Shanghai
      yum install nfs-util bind -y
      yum install rpcbind -y
      wget -P /etc/sysconfig/modules/ http://10.10.10.3/bakup/k8s-14.2/conf/ipvs.modules
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      wget -P /etc/sysctl.d/ http://10.10.10.3/bakup/k8s-14.2/conf/k8s.conf
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      wget http://10.10.10.3/bakup/k8s-14.2/docker-ce-18.09.tar.gz
      tar xf /root/docker-ce-18.09.tar.gz
      yum localinstall /root/docker/* -y
      yum install yum-utils
      yum install -y bind-utils
      echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
      yum install net-snmp-libs-5.7.2-43.el7.x86_64 -y
      yum install -y keepalived
      rm -rf /etc/keepalived/keepalived.conf
      wget http://10.10.10.3/bakup/k8s-14.2/conf/master3/keepalived.conf -P /etc/keepalived/
      wget http://10.10.10.3:/bakup/k8s-14.2/keepalived.service -P /usr/lib/systemd/system/
      systemctl start keeplived
      systemctl enable keepalived
      yum install rpcbind -y
      yum install nfs-utils rpc-bind -y
      systemctl start rpcbind
      systemctl enable rpcbind
      systemctl enable nfs-server
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      yum install yum-utils -y
      wget http://10.10.10.3:/bakup/k8s-14.2/docker-repo.sh
      sh /root/docker-repo.sh
      docker version
      ip address show ens33
      wget http://10.10.10.3:/bakup/k8s-14.2/check_haproxy.sh
      yum install -y haproxy
      rm -rf /etc/haproxy/haproxy.cfg
      wget  http://10.10.10.3:/bakup/k8s-14.2/haproxy.cfg -P /etc/haproxy/
      systemctl enable haproxy
      systemctl start haproxy
      ss -lnt | grep 16443
      rm -rf /etc/hosts
      wget http://10.10.10.3/bakup/k8s-14.2/hosts -P /etc/
      docker login -u admin -p qwe harbor.cn
      wget http://10.10.10.3:/bakup/k8s-14.2/unzip/kubectl-install.tar.gz
      wget http://10.10.10.3:/bakup/k8s-14.2/install-k8s.sh
      tar xf /root/kubectl-install.tar.gz
      cd /root/kubectl-install/
      yum localinstall /root/kubectl-install/kubelet/* -y
      yum localinstall /root/kubectl-install/kubectl/* -y
      yum localinstall /root/kubectl-install/kubeadm/* -y
      systemctl enable kubelet
      systemctl start kubelet
      systemctl stop keepalived
      systemctl start keepalived
      systemctl restart haproxy
      mkdir -p /etc/kubernetes/pki/etcd
      "
}

install_k8s_d()
{
      ssh $k8s_d "setenforce 0
      sed -i s/enforcing/disabled/g /etc/selinux/config
      systemctl stop firewalld
      systemctl disable firewalld
      swapoff -a
      sed -i 's/.*swap.*/#&/' /etc/fstab
      timedatectl set-timezone Asia/Shanghai
      yum install nfs-util bind -y
      yum install rpcbind -y
      wget -P /etc/sysconfig/modules/ http://10.10.10.3/bakup/k8s-14.2/conf/ipvs.modules
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      wget -P /etc/sysctl.d/ http://10.10.10.3/bakup/k8s-14.2/conf/k8s.conf
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      wget http://10.10.10.3/bakup/k8s-14.2/docker-ce-18.09.tar.gz
      tar xf /root/docker-ce-18.09.tar.gz
      yum localinstall /root/docker/* -y
      yum install yum-utils
      yum install -y bind-utils
      echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
      yum install rpcbind -y
      yum install nfs-utils rpc-bind -y
      systemctl start rpcbind
      systemctl enable rpcbind
      systemctl enable nfs-server
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      yum install yum-utils -y
      wget http://10.10.10.3:/bakup/k8s-14.2/docker-repo.sh
      sh /root/docker-repo.sh
      docker version
      mkdir -p /etc/docker/certs.d/harbor.cn/
      rm -rf /etc/hosts
      wget http://10.10.10.3/bakup/k8s-14.2/hosts -P /etc/
      docker login -u admin -p qwe harbor.cn
      wget http://10.10.10.3:/bakup/k8s-14.2/unzip/kubectl-install.tar.gz
      wget http://10.10.10.3:/bakup/k8s-14.2/install-k8s.sh
      tar xf /root/kubectl-install.tar.gz
      cd /root/kubectl-install/
      yum localinstall /root/kubectl-install/kubelet/* -y
      yum localinstall /root/kubectl-install/kubectl/* -y
      yum localinstall /root/kubectl-install/kubeadm/* -y
      systemctl enable kubelet
      systemctl start kubelet
      mkdir -p /etc/kubernetes/pki/etcd"
}

install_k8s_e()
{
      ssh $k8s_e "setenforce 0
      sed -i s/enforcing/disabled/g /etc/selinux/config
      systemctl stop firewalld
      systemctl disable firewalld
      swapoff -a
      sed -i 's/.*swap.*/#&/' /etc/fstab
      timedatectl set-timezone Asia/Shanghai
      yum install nfs-util bind -y
      yum install rpcbind -y
      wget -P /etc/sysconfig/modules/ http://10.10.10.3/bakup/k8s-14.2/conf/ipvs.modules
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      wget -P /etc/sysctl.d/ http://10.10.10.3/bakup/k8s-14.2/conf/k8s.conf
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      wget http://10.10.10.3/bakup/k8s-14.2/docker-ce-18.09.tar.gz
      tar xf /root/docker-ce-18.09.tar.gz
      yum localinstall /root/docker/* -y
      yum install yum-utils
      yum install -y bind-utils
      echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
      yum install rpcbind -y
      yum install nfs-utils rpc-bind -y
      systemctl start rpcbind
      systemctl enable rpcbind
      systemctl enable nfs-server
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      yum install yum-utils -y
      wget http://10.10.10.3:/bakup/k8s-14.2/docker-repo.sh
      sh /root/docker-repo.sh
      docker version
      mkdir -p /etc/docker/certs.d/harbor.cn/
      rm -rf /etc/hosts
      wget http://10.10.10.3/bakup/k8s-14.2/hosts -P /etc/
      docker login -u admin -p qwe harbor.cn
      wget http://10.10.10.3:/bakup/k8s-14.2/unzip/kubectl-install.tar.gz
      wget http://10.10.10.3:/bakup/k8s-14.2/install-k8s.sh
      tar xf /root/kubectl-install.tar.gz
      cd /root/kubectl-install/
      yum localinstall /root/kubectl-install/kubelet/* -y
      yum localinstall /root/kubectl-install/kubectl/* -y
      yum localinstall /root/kubectl-install/kubeadm/* -y
      systemctl enable kubelet
      systemctl start kubelet
      mkdir -p /etc/kubernetes/pki/etcd"
}

install_k8s_f()
{
      ssh $k8s_f "setenforce 0
      sed -i s/enforcing/disabled/g /etc/selinux/config
      systemctl stop firewalld
      systemctl disable firewalld
      swapoff -a
      sed -i 's/.*swap.*/#&/' /etc/fstab
      timedatectl set-timezone Asia/Shanghai
      yum install nfs-util bind -y
      yum install rpcbind -y
      wget -P /etc/sysconfig/modules/ http://10.10.10.3/bakup/k8s-14.2/conf/ipvs.modules
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      wget -P /etc/sysctl.d/ http://10.10.10.3/bakup/k8s-14.2/conf/k8s.conf
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      wget http://10.10.10.3/bakup/k8s-14.2/docker-ce-18.09.tar.gz
      tar xf /root/docker-ce-18.09.tar.gz
      yum localinstall /root/docker/* -y
      yum install yum-utils
      yum install -y bind-utils
      echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
      yum install rpcbind -y
      yum install nfs-utils rpc-bind -y
      systemctl start rpcbind
      systemctl enable rpcbind
      systemctl enable nfs-server
      chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4
      yum install ipset ipvsadm -y
      sysctl --system
      yum install -y yum-utils device-mapper-persistent-data lvm2
      yum install yum-utils -y
      wget http://10.10.10.3:/bakup/k8s-14.2/docker-repo.sh
      sh /root/docker-repo.sh
      docker version
      mkdir -p /etc/docker/certs.d/harbor.cn/
      rm -rf /etc/hosts
      wget http://10.10.10.3/bakup/k8s-14.2/hosts -P /etc/
      docker login -u admin -p qwe harbor.cn
      wget http://10.10.10.3:/bakup/k8s-14.2/unzip/kubectl-install.tar.gz
      wget http://10.10.10.3:/bakup/k8s-14.2/install-k8s.sh
      tar xf /root/kubectl-install.tar.gz
      cd /root/kubectl-install/
      yum localinstall /root/kubectl-install/kubelet/* -y
      yum localinstall /root/kubectl-install/kubectl/* -y
      yum localinstall /root/kubectl-install/kubeadm/* -y
      systemctl enable kubelet
      systemctl start kubelet
      mkdir -p /etc/kubernetes/pki/etcd"
}

main ()
{
      install_k8s_a
      install_k8s_b
      install_k8s_c
      install_k8s_d
      install_k8s_e
      install_k8s_f
}
main
