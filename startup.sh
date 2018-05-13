#!/bin/bash

BC=/etc/apache2/sites-available/bugzilla.conf

MY_HOSTNAME=${WWW_HOSTNAME:-${VIRTUAL_HOST:-bugzilla}}
V_HOSTNAME=`echo "${MY_HOSTNAME}" | cut -f1 -d:`

echo "${TIMEZONE:-Europe/Berlin}" >/etc/timezone

cat bugzilla.conf | sed \
	-e "s/V_HOSTNAME/${V_HOSTNAME}/" \
	-e "s/WWW_HOSTNAME/${MY_HOSTNAME}/" \
	-e "s/SERVER_ADMIN/${SERVER_ADMIN:-www-admin@${MY_HOSTNAME}}/" >${BC}
a2ensite bugzilla
a2enmod cgi headers expires
service apache2 start


LD=/var/www/html/bugzilla
LC=${LD}/localconfig

if [ ! -f ${LC} ] ; then
  if [ ! -d ${LD} ] ; then
	  mkdir -p ${LD}
  else
	  rm -rf ${LD}/*
  fi

  (cd bugzilla; cp -a . ${LD})
  (cd ${LD}; ./checksetup.pl)

  cat ${LC} | sed \
	-e "s/^\$db_host.*;/\$db_host = '${DB_HOST}';/" \
	-e "s/^\$db_name.*;/\$db_name = '${DB_NAME}';/" \
	-e "s/^\$db_user.*;/\$db_user = '${DB_USER}';/" \
	-e "s/^\$db_pass.*;/\$db_pass = '${DB_PASSWD}';/" \
	-e "s/^\$webservergroup.*;/\$webservergroup = 'www-data';/" \
	-e "s/^\$db_port.*;/\$db_port = ${DB_PORT:-0};/" \
	-e "s/DB_PORT/${DB_PORT:-0}/" >/tmp/localconfig
  mv /tmp/localconfig ${LC}
  (cd ${LD}; ./checksetup.pl)
  (cd ${LD}; chown -R www-data:www-data .)

fi

 /usr/sbin/sshd -D
exit 0
