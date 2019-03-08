#!/bin/sh
TIMECRON1=${TIMECRON:-300}

while :
do
  fetchmail -f /data/etc/fetchmailrc -i /data/fetchmail/.fetchids --pidfile /data/fetchmail/.fetchmail.pid
  sleep $TIMECRON1
done
