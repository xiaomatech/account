#!/usr/bin/env bash

yum  install -y ipa-server bind-dyndb-ldap ipa-server-trust-ad ipa-server-dns ipa-admintools rng-tools authconfig

yum install -y freeradius freeradius-utils freeradius-ldap freeradius-krb5

yum localinstall -y rpm/*.rpm

service iptables stop
chkconfig iptables off
systemctl stop firewalld
systemctl disable firewalld

ipa-server-install --domain=meizu.mz--realm=MEIZU.MZ --setup-dns --no-forwarders -U

kinit admin

ipa config-mod --defaultshell=/bin/bash

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