#!/usr/bin/env bash

yum  install -y ipa-server bind-dyndb-ldap ipa-server-trust-ad ipa-server-dns ipa-admintools rng-tools authconfig

yum install -y freeradius freeradius-utils freeradius-ldap freeradius-krb5

yum localinstall -y rpm/*.rpm

service iptables stop
chkconfig iptables off
systemctl stop firewalld
systemctl disable firewalld

sed -i.orig  '/zone "\." IN/,+3 s/^/#/' /etc/named.conf

service named restart

ipa-server-install --domain=meizu.mz --realm=MEIZU.MZ --setup-dns --ssh-trust-dns --mkhomedir --no-forwarders -U \
    --hostname=`hostname -f` --ip-address=10.3.140.42 --auto-reverse -a admin_password -p dir_admin_password

kinit admin

ipa config-mod --defaultshell=/bin/bash

#Configure the reverse dns
#ipa dnszone-add --allow-sync-ptr=true --dynamic-update=true meizu.mz

#Configure dns forwards
#ipa dnsforwardzone-add name --forwarder forwarder --forward-policy policy

#Configure reverse entries
#ipa dnsrecord-add meizu.mz bbs.web01.gz.meizu.mz -a-rec 10.3.140.43

#for replica
ipa-replica-prepare idm2.meizu.mz
scp /var/lib/ipa/replica-info-idm2.meizu.mz.gpg  root@idm2.meizu.mz:/var/lib/ipa/


#添加用户：
#ipa user-add test --uid=1001 --gid=1001

#修改用户密码：
#ipa passwd test

#查询添加用户信息：
#ldapsearch -x -b "dc=meizu, dc=mz" uid=test

#GSS 加密查询：
#ldapsearch -Y GSSAPI uid=test -LLL