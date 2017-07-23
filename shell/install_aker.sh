#!/usr/bin/env bash

yum -y install epel-release 
yum -y install python2-paramiko python-configparser python-redis python-urwid python2-wcwidth redis
 
git clone https://github.com/aker-gateway/Aker.git /usr/bin/aker/
 
chmod 755 /usr/bin/aker/aker.py
chmod 755 /usr/bin/aker/akerctl.py

mkdir /var/log/aker
chmod 777 /var/log/aker

echo -ne '\nMatch Group *,!root
ForceCommand /usr/bin/aker/aker.py\n'>>/etc/ssh/sshd_config
