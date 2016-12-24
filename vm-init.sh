#!/bin/bash

sed -i -e '/^SELINUX/ c SELINUX=disabled' /etc/selinux/config
systemctl disable firewalld
yum install wget zip unzip gzip vim net-tools -y
####echo devops |passwd --stdin root
#sed -i -e '/^Password/ c PasswordAuthentication yes' -e '/^PermitRootLogin/ d' -e '/#PermitRootLogin/ c PermitRootLogin yes' -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
sed -i -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
reboot

