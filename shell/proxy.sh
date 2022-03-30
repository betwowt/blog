#!/bin/bash


proxy_ip=192.168.1.1
proxy_port=1080
proxy_protocol=socks5

sudo apt install git make gcc -y

sudo bash -c 'cat << EOF > /etc/proxy

http_proxy=$proxy_protocol://$proxy_ip:$proxy_port
https_proxy=$http_proxy
ftp_proxy=$http_proxy
no_proxy=10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1
export http_proxy https_proxy ftp_proxy no_proxy

EOF'

sudo bash -c 'cat << EOF > /etc/unproxy

unset http_proxy https_proxy ftp_proxy no_proxy 

EOF'


. /etc/proxy

git clone https://github.com/rofl0r/proxychains-ng.git
cd proxychains-ng
./configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
sudo make install-config
rm -rf proxychains-ng

str1="socks4 	127.0.0.1 9050"
str2="$proxy_protocol  $proxy_ip $proxy_port"
command=s@$str1@$str2@
sed -i "$command" /etc/proxychains.conf