#!/usr/bin/env bash

yum install -y ipa-client ipa-admintools openldap-clients authconfig

service iptables stop
chkconfig iptables off
systemctl stop firewalld
systemctl disable firewalld

#case 2
ipa-client-install -enable-dns-updates -U -p join_account -w join_passwd --domain=meizu.mz --realm=MEIZU.MZ --server=idm1.meizu.mz \
    --mkhomedir --unattended --force-join --all-ip-addresses