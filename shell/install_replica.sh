#!/usr/bin/env bash

yum  install -y ipa-server bind-dyndb-ldap ipa-server-trust-ad ipa-server-dns ipa-admintools rng-tools authconfig
yum install -y freeradius freeradius-utils freeradius-ldap freeradius-krb5
yum localinstall -y rpm/*.rpm

service iptables stop
chkconfig iptables off
systemctl stop firewalld
systemctl disable firewalld

ipa-replica-install /var/lib/ipa/replica-info-idm2.meizu.mz.gpg -U --setup-ca --setup-dns --no-forwarders --auto-reverse --no-ntp --skip-conncheck


kinit admin
ipa-replica-manage list