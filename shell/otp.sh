#!/usr/bin/env bash

#查询所有ipa用户并打印

ipa user-find | grep User | awk -F ':''{print $2}' > /tmp/userlist.txt

#删除不需要处理的用户，默认admin、autoenroll用户不进行处理

if [ -f /tmp/userlist.txt ]; then
     cat /tmp/userlist.txt | sed '/admin/d' | sed '/autoenroll/d' >/tmp/newuserlist.txt
     rm -f /tmp/userlist.txt
else if [ -f /tmp/newuserlist.txt ]; then
     #修改所有用户的认证方式为otp
     #为每个用户启用令牌
     for USERNAME in `cat newuserlist.txt`
     do
                     ipauser-mod $USERNAME --user-auth-type=otp
                     ipa otptoken-add --type=totp  \
                     --not-before=20170112000000Z  \
                     --not-after=20200113000000Z  \
                     --owner=$USERNAME  \
                     --algo=sha512 --digits=8  \
                     --interval=60 \
                     --desc="token for $USERNAME"  $USERNAME >>otplist
     done
else
     echo "user auth type modify failed"
fi