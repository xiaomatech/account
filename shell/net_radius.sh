#!/usr/bin/env bash


cho -ne "
ldap
if ((ok || updated) && User-Password) {
    update {
        control:Auth-Type := ldap
    }
}

Auth-Type LDAP {
    ldap
}
" >>/etc/raddb/sites-enabled/default

cho -ne "
ldap
if ((ok || updated) && User-Password) {
     update {
         control:Auth-Type := ldap
     }
}

Auth-Type LDAP {
    ldap
}

" >>/etc/raddb/sites-enabled/inner-tunnel

ln -s /etc/raddb/mods-available/ldap /etc/raddb/mods-enabled/

sed -i 's/server = "ldap.example.com"/server = "idm1.meizu.mz"/' /etc/raddb/mods-enabled/ldap
sed -i 's/base_dn = "dc=example,dc=com"/base_dn = "dc=meizu,dc=mz"' /etc/raddb/mods-enabled/ldap

systemctl enable radiusd
systemctl restart radiusd

#test
#radtest <user> <userpassword> <freeradius server> <port> <radius secret>