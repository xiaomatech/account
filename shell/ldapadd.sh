#!/usr/bin/env bash

ldapadd -D "cn=Manager,ou=Control,dc=meizu,dc=mz" -w secret -f ldif/cisco.ldif
ldapadd -D "cn=Manager,ou=Control,dc=meizu,dc=mz" -w secret -f ldif/wifi.ldif
ldapadd -D "cn=Manager,ou=Control,dc=meizu,dc=mz" -w secret -f ldif/hadoop.ldif