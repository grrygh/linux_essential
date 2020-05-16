#! /bin/bash

# This script is to poll gravity.db from pihole production server
# to this host docker pihole.

# Rsync from production pihole.
rsync -a pi@10.1.1.10:/etc/pihole/gravity.db /home/pi/etc-pihole/
docker exec -it pihole pihole restartdns reload-list
docker exec -it pihole pihole -g
echo "$(date)" > pihole_gravity.log

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "0 8 * * * bash /home/pi/pihole_gravity.sh" >> mycron
#install new cron file
crontab mycron
rm mycron
