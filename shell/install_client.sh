#!/usr/bin/env bash

yum install -y ipa-client ipa-admintools openldap-clients authconfig

service iptables stop
chkconfig iptables off
systemctl stop firewalld
systemctl disable firewalld

#case 1
#run this on the ipa server first
#ipa host-add --password=secret idm1.meizu.mz
#then enroll the client
#ipa-client-install --mkhomedir --domain=meizu.mz --server=idm1.meizu.mz --unattended -w secret

#case 2
ipa-client-install -U -p join_account -w join_passwd --domain=meizu.mz --realm=MEIZU.MZ --server=idm1.meizu.mz \
    --mkhomedir --hostname=`hostname -f`  --force-join --all-ip-addresses