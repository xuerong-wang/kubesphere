#!/bin/bash
IP=$(hostname -i|awk '{print $2}')
setenforce 0	
#sed -i s/enforcing/disabled/g /etc/selinux/config
systemctl stop firewalld
systemctl disbale firewalld
swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab
#yum install nfs-util bind -y 
systemctl start nfs rpcbind
cat > /etc/exports << EOF
/data/nfs *(insecure,rw,async,no_root_squash)		
/data/mysql *(insecure,rw,async,no_root_squash)	
/data/nginx *(insecure,rw,async,no_root_squash)
EOF
systemctl restart nfs rpcbind
wget http://10.10.10.3/docker-compose -P /usr/local/bin/ 
chmod +x /usr/local/bin/docker-compose
docker-compose --version
wget http://10.10.10.3/bakup/k8s-14.2/docker-ce-18.09.tar.gz
tar xf docker-ce-18.09.tar.gz
cd /root/docker
yum localinstall * -y
wget http://10.10.10.3/docker-repo.sh -P /root
sh /root/docker-repo.sh
hostname -i| awk '{print $2}' >> /etc/hosts
sed -i "3s/$/ harbor.cn/g" /etc/hosts
mkdir -p  /home/k8s/cert_harbor
cd /home/k8s/cert_harbor
openssl genrsa  -out  ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/C=CN/ST=Beijing/L=Beijing/O=ccx/OU=plat/CN=$IP" -key ca.key -out ca.crt
openssl genrsa -out harbor.cn.key 4096
openssl req -sha512 -new -subj "/C=CN/ST=Beijing/L=Beijing/O=ccx/OU=plat/CN=$IP" -key harbor.cn.key -out harbor.cn.csr
wget http://10.10.10.3/externalfile.ext -P /home/k8s/cert_harbor
openssl x509 -req -sha512 -days 3650 -extfile externalfile.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in harbor.cn.csr -out harbor.cn.crt
openssl x509 -inform PEM -in harbor.cn.crt -out harbor.cn.cert
wget http://10.10.10.3/bakup/k8s-14.2/unzip/harbor-offline-installer-v1.10.1.tgz -P /home/k8s/
cd /home/k8s/
tar xf harbor-offline-installer-v1.10.1.tgz
cd /home/k8s/harbor
docker load < harbor.v1.10.1.tar.gz
sed -i -e "5s/reg.mydomain.com/$IP/g" -e "17s/\/your\/certificate\/path/\/home\/k8s\/cert_harbor\/harbor.cn.crt/g" -e "18s/\/your\/private\/key\/path/\/home\/k8s\/cert_harbor\/harbor.cn.key/g" /home/k8s/harbor/harbor.yml
sh /home/k8s/harbor/prepare
sh /home/k8s/harbor/install.sh
curl $IP
cd /root
cat > createproject.json << EOF
{

  "project_name": "s6000",

  "public": 1

}
EOF
sleep 30s 
curl -u "admin:Harbor12345" -X POST -H "Content-Type: application/json" "https://$IP/api/projects" -d @createproject.json --insecure
wget http://10.10.10.3/bakup/k8s-14.2/unzip/s6000-images.tar.gz
tar xf s6000-images.tar.gz
cd /root/s6000-images/  
sh /root/s6000-images/docker-push.sh
docker login -u admin -p Harbor12345 harbor.cn
cat > /usr/lib/systemd/system/harbor.service << 'EOF'
[Unit]
Description=Harbor
After=docker.service systemd-networkd.service systemd-resolved.service
Requires=docker.service
Documentation=http://github.com/vmware/harbor
 
[Service]
Type=simple
Restart=on-failure
RestartSec=5
Environment=harbor_install_path=/data/packages
ExecStart=/usr/local/bin/docker-compose -f ${harbor_install_path}/harbor/docker-compose.yml up
ExecStop=/usr/local/bin/docker-compose -f ${harbor_install_path}/harbor/docker-compose.yml down
 
[Install]
WantedBy=multi-user.target
EOF
systemctl enable harbor
systemctl start harbor
systemctl status harbor
wget http://10.10.10.3/docker-push.sh -P /root
sh /root/docker-push.sh 
