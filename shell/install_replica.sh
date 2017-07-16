#!/usr/bin/env bash

yum  install -y ipa-server bind-dyndb-ldap ipa-server-trust-ad ipa-server-dns ipa-admintools rng-tools authconfig
yum localinstall -y rpm/*.rpm

service iptables stop
chkconfig iptables off
systemctl stop firewalld
systemctl disable firewalld

ipa-replica-install /root/replica-info-idm2.meizu.mz.gpg --skip-conncheck


kinit admin
ipa-replica-manage list