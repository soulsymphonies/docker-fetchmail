# docker-fetchmail
[![](https://images.microbadger.com/badges/image/cguenther/docker-fetchmail.svg)](https://microbadger.com/images/cguenther/docker-fetchmail "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/cguenther/docker-fetchmail.svg)](https://microbadger.com/images/cguenther/docker-fetchmail "Get your own version badge on microbadger.com")

alpine linux with fetchmail and logrotate, orchestrated via supervisor

```
docker-compose up -d
```
if you are using `mailcow-dockerized` and want to integrate fetchmail, there is a sample `docker-compose-mailcow.yml` file for this scenario, just adjust your network settings if you changed the mailcow-dockerized defaults, to start the container use the following command
```
docker-compose -f docker-compose-mailcow.yml up -d
```
TIMECRON: Time to Recheck mail, if nothing set it defaults to 300 seconds (which should accept the most mail servers)

# configuration
change `conf/fetchmailrc` file and adjust it to your own needs
 - let the postmaster run as fetchmail
 - use the /data/log/fetchmail.log logging path for correct logrotate interop
 - use the preconnect line with the `logdate.sh` script for timestamps in your logs
 - use the environment variable TZ to specify your timezone

 configuration example:

```conf
set no syslog
set logfile /data/log/fetchmail.log

set postmaster "postmaster@domain.com"

poll your.mail.server with proto IMAP
  user 'user@domain.com' pass 'user-password' is 'localaddress@domain.com'
  preconnect "logdate.sh >> /data/log/fetchmail.log"
  ssl
  smtphost mailserver/port
  smtpname localaddress@domain.com
keep
```
for mailcow-dockerized you can use smtphost `postfix/588`

# docker-compose example

```yml
version: '3.5'

services:
  fetchmail :
    image: soulsymphonies/docker-fetchmail:0.1
    build: .
    hostname: fetchmail
    environment:
      - TIMECRON=60
      - TZ=Europe/Berlin
    volumes:
      - fetchmail-log:/data/log
      - ${PWD}/conf/fetchmailrc:/data/etc/fetchmailrc
    restart: unless-stopped
    networks:
      default:
        aliases:
          - fetchmail 

networks:
  fetchmail-net:
    driver: bridge
    name: fetchmail_net
    ipam:
      driver: default
      config:
        - subnet: 172.22.22.0/24

volumes:
fetchmail-log:
```
The fetchmail container logs directly into the docker volume `fetchmail-log`
