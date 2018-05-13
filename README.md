# bugzilla

This is a complete bugzilla-4.4 installation running on a apache-2.4, and conecting to an extern mysql-server.
The container also creates a user "bugzilla" with passwort "bugzilla". So you can ssh into the container and sudo around.

# PORTS
The container exports 80 and port 22

# VOLUMES
The container exports 3 volumes
* /var/www/html/bugzilla
* /var/log/apache2
* /home/bugzilla

# RUN
docker run -d \
	--name bugzilla \
	-p 8666:80  \
	-p 8022:22  \
	-v /usr/local/share/volumes/bugzilla/bugzilla:/var/www/html/bugzilla \
	-v /usr/local/share/volumes/bugzilla/log:/var/log/apache2 \
	-v /usr/local/share/volumes/bugzilla/bugzilla_home:/home/bugzilla \
	-h bugzilla.example.com \
	-e "WWW_HOSTNAME=bugzilla.example.com:8666" \
	-e "SERVER_ADMIN=admin@example.com" \
	-e "TIMEZONE=Europe/Berlin" \
	-e "DB_HOST=bugzilladb.example.com" \
	-e "DB_NAME=bugzilla" \
	-e "DB_USER=bugzilla" \
	-e "DB_PASSWD=mysecretpasswd" \
	cssdata/bugzilla
  
  # WARNING
  * If you map port 80 to something else, you have to set the WWW_HOSTNAME accordingly (see above)
  * You have to set a valid TIMEZONE. Otherwise bugzilla will throw errors at you (see above)
  * The default user/passwd is "bugzilla" / "bugzilla"! So, please don't forget to ssh into the container and change the default passwd
  * Unfortunately bugzilla stores data in the www-tree so you have to mount the "/var/www/html/bugzilla" volume if you don't want to loose data between restarts.
  
  # TODO
  * This is my very first docker. The image is based on ubuntu and gets quite big. There is probably quite some room for optimizations
  * I just tested the container against our already existing mysql-database. I still have to test a new installation (empty database)

