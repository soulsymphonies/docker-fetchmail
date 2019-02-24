#!/bin/sh

# setting up log folder and permissions
if [ ! -d /data/log ]; then
	mkdir -p /data/log
fi

if [ ! -d /data/fetchmail ]; then
	mkdir -p /data/fetchmail
	chown -cR fetchmail:fetchmail /data/fetchmail/
fi

chown -cR fetchmail:fetchmail /data/etc/
chmod 0600 /data/etc/fetchmailrc

if [ ! -d /data/log ]; then
	mkdir -p /data/log
fi

if [ ! -f /data/log/fetchmail.log ]; then
	touch /data/log/fetchmail.log
	chown fetchmail:fetchmail /data/log/fetchmail.log
fi

if [ ! -f /var/log/messages ]; then
	touch /var/log/messages
fi

# set up timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo "$TZ" > /etc/timezone

# wait forever
trap : TERM INT
tail -f /dev/null & wait
