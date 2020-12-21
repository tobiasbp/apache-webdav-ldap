# apache-webdav-ldap
A docker image running Apache serving a WebDAV site with ldap authorization. 

Accepts traffic on port 80. Does not support HTTPS. You are expected to run this image behind a proxy doing the encryption.


# Reloading apache
pid is here: /usr/local/apache2/logs/httpd.pid
kill -HUP 1
