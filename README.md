# apache-webdav-ldap
A docker image running Apache serving a WebDAV site with ldap authorization. 

Accepts traffic on port 80 (By default). Does not support HTTPS. You are expected to run this image behind a proxy doing the encryption.

# Configuration
Configure the using these env variables

* APACHE_LDAP_URL "ldap://ldap.example.com/ou=webdav,dc=example,dc=com?uid?sub?(objectClass=*)"
* APACHE_LDAP_BIND_DN "cn=webdav-user,dc=example,dc=com"
* APACHE_LDAP_PASSWORD "*****"
* APACHE_LDAP_GROUP_ATTRIBUTE_IS_DN "off"
* APACHE_LDAP_GROUP_ATTRIBUTE "memberUid"

* APACHE_LOG_LEVEL warn
* APACHE_PORT 80

* LDAP_TLS_REQCERT always

# Reloading apache
apachectl restart

# Testing
use client _cadaver_: `cadaver http://localhost:8080/share_1`

# Security
What happens if you have a shared dir protected by LDAP login, and you then remove the dir
from the list of WevDAV shares? Would the dir not be served like a standard dir, revealing
the content to anyone?
