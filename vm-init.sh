#!/bin/bash

curl https://raw.githubusercontent.com/versionit/docs/master/ps1.sh > /etc/profile.d/ps1.sh
chmod +x /etc/profile.d/ps1.sh
if [ $(rpm -qa |grep ^base |awk -F . '{print $(NF-1)}') = "el6" ]; then 
    sed -i -e '/^SELINUX/ c SELINUX=disabled' /etc/selinux/config   
    service iptables off
    service ip6tables off
    yum install wget zip unzip gzip vim net-tools -y
    sed -i -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
    reboot
fi 

sed -i -e '/^SELINUX/ c SELINUX=disabled' /etc/selinux/config
systemctl disable firewalld
yum install wget zip unzip gzip vim net-tools -y
####echo devops |passwd --stdin root
#sed -i -e '/^Password/ c PasswordAuthentication yes' -e '/^PermitRootLogin/ d' -e '/#PermitRootLogin/ c PermitRootLogin yes' -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
sed -i -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
reboot

