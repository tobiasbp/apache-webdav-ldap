FROM httpd:2.4-alpine

#######################################
# DEFAULTS FOR  ENVIRONMENT VARIABLES #
#######################################

# List of shares to serve
ENV WEBDAV_SHARES "share_1 share_2"

# The require directive for each webdav share (Sub dir)
ENV APACHE_SHARE_REQUIRE_1 ldap-group
ENV APACHE_SHARE_REQUIRE_2 cn=\$DAV_SHARE_NAME,ou=groups,ou=webdav,dc=example,dc=com

# User STARTTLS by default
ENV APACHE_LDAP_TRUSTED_MODE STARTTLS

# Credentials for binding to the LDAP server
ENV APACHE_LDAP_BIND_DN "cn=webdav-user,dc=example,dc=com"
ENV APACHE_LDAP_PASSWORD "*****"

ENV APACHE_LDAP_URL "ldap://ldap.example.com/ou=webdav,dc=example,dc=com?uid?sub?(objectClass=person)"

# Is the attribute for a group member the user's DN?
ENV APACHE_LDAP_GROUP_ATTRIBUTE_IS_DN "off"

# What is the name of the attribute in the group holding members?
ENV APACHE_LDAP_GROUP_ATTRIBUTE "memberUid"

# The Apache log level
# Possible values include: debug, info, notice, warn, error, crit, alert, emerg.
ENV APACHE_LOG_LEVEL warn

# The port Apache will listen on
ENV APACHE_PORT 80

# The value used for ServerName (suffixed with port)
ENV APACHE_SERVER_NAME webdav.example.com

# Apache will tell user's to contact this email on errors
ENV ADMIN_EMAIL "admin@example.com"

# openLDAP. Set to "never" for self signed certs
ENV LDAP_TLS_REQCERT always

ENV APACHE_LDAP_LIBRARY_DEBUG 0

# LDAP cache
ENV APACHE_LDAP_SHARED_CACHE_SIZE 500000
ENV APACHE_LDAP_CACHE_ENTRIES 1024
ENV APACHE_LDAP_CACHE_TTL 600
ENV APACHE_LDAP_OP_CACHE_ENTRIES 1024
ENV APACHE_LDAP_OP_CACHE_TTL 600


####################
# COPY CONFG FILES #
####################

# Apache config files
COPY ./src/apache2 /usr/local/apache2

# The openLDAP config file
COPY ./src/ldap.conf /etc/openldap/

# The script for configuring, and then running Apache
COPY ./src/httpd-webdav-foreground /usr/local/bin/


#################
# RUN CONTAINER #
#################

# Update apache config based on ENV variables and run Apache
ENTRYPOINT ["httpd-webdav-foreground"]
