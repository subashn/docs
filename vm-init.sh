#!/bin/bash

sed -i -e '/^SELINUX/ c SELINUX=disabled' /etc/selinux/config
systemctl disable firewalld
yum install wget zip unzip gzip vim -y
####echo devops |passwd --stdin root
sed -i -e '/^Password/ c PasswordAuthentication yes' -e '/^PermitRootLogin/ d' -e '/#PermitRootLogin/ c PermitRootLogin yes' /etc/ssh/sshd_config
reboot

