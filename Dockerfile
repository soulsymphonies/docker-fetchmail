FROM alpine:latest
MAINTAINER cguenther.tu.chemnitz@gmail.com

#install necessary packages
RUN apk update; \
    apk upgrade; \
    apk add fetchmail openssl logrotate tzdata;

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

#set startup script rights
RUN chmod 0700 /bin/start.sh; \
    chown fetchmail:fetchmail /bin/fetchmail_daemon.sh

VOLUME ["/data"]
CMD ["/bin/sh", "/bin/start.sh"]
