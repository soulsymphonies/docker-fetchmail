#!/bin/sh

run()
{ 
    chmod 0600 /data/etc/fetchmailrc
    chown fetchmail:fetchmail /data/etc/
    chown fetchmail:fetchmail /data/etc/fetchmailrc
    touch /data/log/fetchmail.log
    chown fetchmail:fetchmail /data/log/fetchmail.log
	# set timezone
	cp /usr/share/zoneinfo/$TZ /etc/localtime
	echo "$TZ" > /etc/timezone
    # run cron daemon, which executes the logrotate job
    crond
    # collect log informations for docker logs or docker-compose logs
    tail -n 50 -f /data/log/fetchmail.log &
    # run fetchmail as endless loop with reduced permissions
    su -s /bin/sh -c '/bin/sh /bin/fetchmail_daemon.sh' fetchmail
}

run

