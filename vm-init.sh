#!/bin/bash

Print() {

	case $3 in 
		B) COL="\e[34m" ;;
		G) COL="\e[32m" ;;
		Y) COL="\e[33m" ;;
		R) COL="\e[31m" ;;
	esac

			if [ "$1" = SL ]; then 
				echo -n -e "$COL$2\e[0m"
			elif [ "$1" = NL ]; then 
				echo -e "$COL$2\e[0m"
			else
				echo -e "$COL$2\e[0m"
			fi
}

SELINUX() {
    Print "SL" "=>> Checking SELINUX.. " "B"
	S=$(sestatus  |grep 'SELinux status'  |awk '{print $NF}')
	if [ "$S" = "enabled" ]; then 
		Print "NL" "Enabled.." "R"
		Print "SL" "Disabling SELINUX.." B
		sed -i -e '/^SELINUX/ c SELINUX=disabled' /etc/selinux/config
		Print "NL" "Success" G
		rreq=yes
	else
		Print NL "Disabled" G
	fi 
}

PACK() {

	Print SL "=>> Installing base Packages.. " B
	yum install wget zip unzip gzip vim net-tools -y &>/dev/null
	Print NL Success G
}

LENV() {

	Print SL "=>> Setting Enviornment.. " B
	sed -i -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
	curl https://raw.githubusercontent.com/versionit/docs/master/ps1.sh > /etc/profile.d/ps1.sh &>/dev/null
	chmod +x /etc/profile.d/ps1.sh
	Print NL Success G

	Print SL "Do you want to setup idle time shutdown [Y|n]? " B
	read ans
	case "$ans" in 
		n*|N*) : ;;
		y*|Y*|*) 
		### set the script 
			: ;;
	esac
}

if [ `id -u` -ne 0 ]; then 
	Print "NL" "You Should be root user to perform this Script" R
	exit 2
fi


if [ $(rpm -qa |grep ^base |awk -F . '{print $(NF-1)}') = "el6" ]; then 
	SELINUX
    service iptables off && service ip6tables off
    if [ $? -eq 0 ]; then 
		Print NL Success G
	else
		Print NL Failure R
	fi
	Print SL "=>> Installing base Packages.. " B
    yum install wget zip unzip gzip vim net-tools -y &>/dev/null
    Print NL Success G

	LENV
	PACK

	Print NL "Run of Init Script .. Completed.. System is ready to use" B 
	exit 0
fi 


Print "SL" "=>> Checking SELINUX.. " "B"
SELINUX
Print "SL" "=>> Disabling Firewall.. " "B"
systemctl disable firewalld &>/dev/null
if [ $? -eq 0 ]; then 
	Print NL Success G
else
	Print NL Failure R
fi

PACK
LENV

if [ "$rreq" = "yes" ]; then 
	Print "NL" "Rebooting Server.. Try to connect back in 15 sec" R
	reboot
fi

Print NL "Run of Init Script .. Completed.. System is ready to use" B 
