#!/usr/bin/env tac_plus

id = spawnd {
        listen = { port = 49 }
        spawn = {
                instances min = 1
                instances max = 10
        }
        background = yes
}

id = tac_plus {
        access log = /var/log/tac_plus/access/%Y%m%d.log
        accounting log = /var/log/tac_plus/acct/%Y%m%d.log

        mavis module = external {
                setenv LDAP_SERVER_TYPE = "microsoft"
                setenv LDAP_HOSTS = "ldap://idm1.meizu.mz:389"
                setenv LDAP_SCOPE = "sub"
                setenv LDAP_BASE = "cn=users,cn=accounts,dc=meizu,dc=mz"
                setenv LDAP_FILTER= "(uid=%s)"
                #setenv UNLIMIT_AD_GROUP_MEMBERSHIP = "1"
                setenv REQUIRE_TACACS_GROUP_PREFIX = 1
                #上面意思要求 LDAP memberOF 组名里包括 tacacs 前缀，也就是组名需要为"tacacsadmin"、"tacacshelpdesk"
                setenv FLAG_USE_MEMBEROF = 1
                #setenv AD_GROUP_PREFIX = ""
                #以上可以修改 tacacs 前缀，默认为"tacacs"
                exec = /usr/lib/mavis/mavis_tacplus_ldap.pl
        }

        login backend = mavis
        user backend = mavis
        pap backend = mavis
        skip missing groups = yes
        cache timeout = 3600
        #默认两分钟超时，需要重新登录才可以授权，这里改成 1 个小时。

        host = world {
                address = ::/0
                prompt = "Welcome C=%%C Time=%c\n"
                #Crypt password generate by "openssl passwd-1 clear_text_password"
                enable 15 = crypt $1$/ZBGKGvh$ngiTDivqGYxuOGqKREuCj0
                key = "meizu"
        }

        group = admin {
                message = "[Admin privileges]"
                default service = permit
                service = shell {
                        default command = permit
                        default attribute = permit
                        set priv-lvl = 15
                }
        }

        group = helpdesk {
                message = "[Helpdesk privileges]"
                default service = permit
                enable = deny
                service = shell {
                        default command = permit
                        default attribute = permit
                        set priv-lvl = 1
                }
        }
}