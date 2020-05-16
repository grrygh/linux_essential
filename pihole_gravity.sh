#! /bin/bash

# This script is to poll gravity.db from pihole production server
# to this host docker pihole.

rsync -a pi@10.1.1.10:/etc/pihole/gravity.db /home/pi/etc-pihole/
docker exec -it pihole pihole restartdns reload-list
docker exec -it pihole pihole -g
echo "$(date)" > pihole_gravity.log
