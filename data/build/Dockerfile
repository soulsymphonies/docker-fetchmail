FROM alpine:latest
MAINTAINER cguenther.tu.chemnitz@gmail.com

#install necessary packages
RUN apk update; \
    apk upgrade; \
    apk add fetchmail openssl logrotate tzdata supervisor bash;

#set workdir
WORKDIR /data

#setup fetchmail stuff, fetchmail user is created by installing the fetchmail package
RUN chown fetchmail:fetchmail /data; \
    chmod 0744 /data; 

#add logrotate fetchmail config
ADD etc/logrotate.d/fetchmail /etc/logrotate.d/fetchmail
#fix missing file - logrotate
RUN touch /var/log/messages
#add startup script
ADD start.sh /bin/start.sh
#add fetchmail_daemon script
ADD fetchmail_daemon.sh /bin/fetchmail_daemon.sh
# add timestamp script
ADD logdate.sh /bin/logdate.sh
# set execute and permissions for timestamp script
RUN chmod 0700 /bin/logdate.sh \
    && chown fetchmail:fetchmail /bin/logdate.sh

ADD supervisord.conf /etc/supervisord.conf
ADD stop-supervisor.sh /bin/stop-supervisor.sh

#set startup script rights
RUN chmod 0700 /bin/start.sh; \
    chown fetchmail:fetchmail /bin/fetchmail_daemon.sh; \
    chmod 0700 /bin/stop-supervisor.sh; \
    chmod 0700 /bin/fetchmail_daemon.sh;

#set up fetchmail workdir
RUN mkdir -p /data/fetchmail; \
	chown -cR fetchmail:fetchmail /data/fetchmail;

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

VOLUME ["/data/log"]
