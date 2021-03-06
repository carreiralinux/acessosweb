/usr/src/squid-3.5.22/configure --prefix="/usr" \
--libexecdir="/usr/libexec/squid" \
--sysconfdir="/etc/squid" \
--localstatedir="/var" \
--libdir="/usr/lib64/squid" \
--datarootdir="/usr/share/squid" \
--mandir="/usr/man/squid" \
--docdir="/usr/doc/squid" \
--enable-ssl-crtd \
--enable-auto-locale \
--enable-translation \
--enable-disk-io \
--enable-removal-policies="heap,lru" \
--enable-icmp \
--enable-ipv6 \
--enable-delay-pools \
--enable-cache-digests \
--enable-linux-netfilter \
--enable-snmp \
--enable-auth \
--enable-auth-basic="DB,LDAP,NCSA,SMB,SMB_LM" \
--enable-auth-digest="LDAP,file" \
--enable-log-daemon-helpers="DB,file" \
--enable-external-acl-helpers="LDAP_group,session,unix_group,wbinfo_group" \
--enable-err-languages="Portuguese" \
--enable-default-err-language="Portuguese" \
--with-openssl \
--with-default-user="squid" \
--with-logdir="/var/log/squid" \
--with-pidfile="/var/run/squid.pid" \
--with-swapdir="/var/cache/squid" \
--without-netfilter-conntrack \
--with-filedescriptors="65536" \
--libdir="/usr/lib64"
