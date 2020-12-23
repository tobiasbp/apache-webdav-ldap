# apache-webdav-ldap
A docker image running Apache serving directories via WebDAV with ldap authorization.
Each directory (_share_) needs a matching _posixGroup_ in LDAP. The members of the group,
can access the WebDAV share at *http://webdav.example.com/share-name*.
In the container, the files are at stored at  _/usr/local/apache2/webdav/share-name_.
You should probably mount persistent storage at _/usr/local/apache2/webdav_ to preserve
your files across container restarts.

The container accepts traffic on port 80 (By default), and does not support HTTPS.
You are expected to run this image behind a proxy doing the encryption.

The Apache document root is _/usr/local/apache2/htdocs_ containing the file _index.html_. Mount your own
dir there (including _index.html_), to customize what is shown as the root page at _http://webdav.example.com_.


# Configuration
Configure your container using the following env variables. All the variables prefixed with *APACHE_* match apache
configuration variables for Apache modules [mod_authnz_ldap](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html) and
[mod_ldap](https://httpd.apache.org/docs/2.4/mod/mod_ldap.html#ldaptrustedmode).

## WEBDAV_SHARES
List of shares to serve via WebDAV separated by spaces. The default will create shares
*http://webdav.example.com/share_1* and *http://webdav.example.com/share_2*
* Default: *"share_1 share_2"*

## APACHE_SHARE_REQUIRE_1 & APACHE_SHARE_REQUIRE_2
These variables hold the two values making up the configuration of _Require_ for the
shared directories. The default configuration shows how a share could be configured
to only allow users who are members of an LDAP group matching the name of the WebDAV share.
The variable *$DAV_SHARE_NAME* (remember to escape the _$_) holds the name of the share
in the Apache configuration.
[documentation](https://httpd.apache.org/docs/current/mod/mod_authnz_ldap.html#requiredirectives).
* Default (APACHE_SHARE_REQUIRE_1): _ldap-group_
* Default (APACHE_SHARE_REQUIRE_2): _cn=\$DAV_SHARE_NAME,ou=groups,ou=webdav,dc=example,dc=com_


## APACHE_LDAP_TRUSTED_MODE
Configure the use of encryption on the connection to LDAP server.
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_ldap.html#ldaptrustedmode).
* Default: _STARTTLS_

## APACHE_LDAP_BIND_DN
DN of user to bind to LDAP as.
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapbinddn)
* Default: _"cn=webdav-user,dc=example,dc=com"_

## APACHE_LDAP_PASSWORD
The password to use when binding as user *APACHE_LDAP_BIND_DN*.
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapbindpassword)
* Default: _"*****"_

## APACHE_LDAP_URL
The ldap server, attribute of login scope and filter to use when looking up users. You can specify
more than one URL, separated with a space,  for redundancy.
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapurl)
* Default: _"ldap://ldap.example.com/ou=webdav,dc=example,dc=com?uid?sub?(objectClass=person)"_

## APACHE_LDAP_GROUP_ATTRIBUTE_IS_DN
Is the attribute for a group member the user's DN?
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapgroupattributeisdn)
* Default: _"off"_

##  APACHE_LDAP_GROUP_ATTRIBUTE
What is the name of the attribute in the group holding members?
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapgroupattribute)
* Default: _"memberUid"_

## APACHE_LOG_LEVEL
The Apache log level. Possible values include: debug, info, notice, warn, error, crit, alert, emerg.
* Default:  _warn_

## APACHE_PORT
The port Apache will listen on.
* Default: _80_

## ADMIN_EMAIL
Apache will tell users to contact this email on errors
* Default: "admin@example.com"

## APACHE_LDAP_LIBRARY_DEBUG
The apache debug level 7 is max.
* Default: _0_

## APACHE_LDAP_SHARED_CACHE_SIZE
[documentation(https://httpd.apache.org/docs/2.4/mod/mod_ldap.html#ldapsharedcachesize)
* Default: _500000_

## APACHE_LDAP_CACHE_ENTRIES
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_ldap.html#ldapcacheentries)
* Default: _1024_

## APACHE_LDAP_CACHE_TTL
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_ldap.html#ldapcachettl)
* Default: _600_

## APACHE_LDAP_OP_CACHE_ENTRIES
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_ldap.html#ldapopcacheentries)
* Default: _1024_

## APACHE_LDAP_OP_CACHE_TTL
[documentation](https://httpd.apache.org/docs/2.4/mod/mod_ldap.html#ldapopcachettl)
* Default: _600_

## LDAP_TLS_REQCERT
openLDAP parameter in _/etc/openldap/ldap.conf_. Set to "never" for self signed certs.
[documentation](https://linux.die.net/man/5/ldap.conf)
* Default: _always_

# Testing
Use the client [cadaver](http://www.webdav.org/cadaver/) for accessing your WebDAV shares form the command line.
To access *share_1*, you would type `cadaver http://webdav.example.com/share_1`

