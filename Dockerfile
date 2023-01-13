# I'm very new to docker - ubuntu was the next best thing I could think off
FROM ubuntu

EXPOSE 80/tcp
EXPOSE 22/tcp

ENV DB_HOST=bugzilladbhost
ENV DB_NAME=bugzilla
ENV DB_USER=bugzilla
ENV DB_PASSWD=bugzilla

WORKDIR /app

VOLUME ["/var/www/html/bugzilla", "/var/log/apache2", "/home/bugzilla"]

RUN apt-get update \
&& apt-get -y install \
	mysql-client \
	apache2 \
	libappconfig-perl \
	libdate-calc-perl \
	libtemplate-perl \
	libmime-tools-perl \
	build-essential \
	libdatetime-timezone-perl \
	libemail-sender-perl \
	libemail-mime-perl \
	libemail-address-perl \
	libdbi-perl \
	libdbd-mysql-perl \
	libcgi-pm-perl \
	libmath-random-isaac-perl \
	libapache2-mod-perl2 \
	libapache2-mod-perl2-dev \
	libchart-perl \
	libxml-perl \
	libxml-twig-perl \
	perlmagick \
	libgd-graph-perl \
	libsoap-lite-perl \
	libhtml-scrubber-perl \
	libjson-rpc-perl \
	libdaemon-generic-perl \
	libtheschwartz-perl \
	libtest-taint-perl \
	libauthen-radius-perl \
	libfile-slurp-perl \
	libencode-detect-perl \
	libmodule-build-perl \
	libnet-ldap-perl \
	libfile-mimeinfo-perl \
	libhtml-formattext-withlinks-perl \
	libfile-which-perl \
	libgd-dev \
	libmysqlclient-dev \
	graphviz \
	git \
	sudo \
	openssh-server \
&& apt-get -y clean


COPY bugzilla.conf startup.sh /app/
RUN git clone --branch 4.4 https://github.com/bugzilla/bugzilla bugzilla
RUN cd bugzilla; /usr/bin/perl install-module.pl Email::Send

RUN useradd -c "bugzilla user" \
	--home-dir /home/bugzilla \
	--shell /bin/bash \
	--user-group \
	--groups sudo \
	bugzilla

RUN echo "bugzilla:bugzilla" | chpasswd ; mkdir -p /var/run/sshd

ENTRYPOINT ["/app/startup.sh"]
