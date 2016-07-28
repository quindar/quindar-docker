#!/bin/sh
# Program: findMongoDBip.sh
# Purpose: To find 3 internal IP addresses in order to create Mongodb replica set
# Author:  Ray Lai
# Updated: Jun 27, 2016
#

echo "...cleaning up old files"
if [ -f "mongodbIP.sh" ]
then
        echo "Now removing the file mongodbIP.sh."
        rm -f mongodbIP.sh
fi

echo "...extracting data01 IP address"
docker run -p 3101:27017 --name data01 --hostname data01.audacy.space -d -v /mnt/data/staging/data01:/data/db edgarzlin/mongodb

X=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' data01`
export DATA01=$X
echo "export DATA01="$DATA01 >> mongodbIP.sh

echo "...extracting data02 IP address"
docker run -p 3102:27017 --name data02 --hostname data02.audacy.space -d -v /mnt/data/staging/data02:/data/db edgarzlin/mongodb

X=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' data02`
export DATA02=$X
echo "export DATA02="$DATA02 >> mongodbIP.sh

echo "...extracting data03 IP address"
docker run -p 3103:27017 --name data03 --hostname data03.audacy.space -d -v /mnt/data/staging/data03:/data/db edgarzlin/mongodb

X=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' data03`
export DATA03=$X
echo "export DATA03="$DATA03 >> mongodbIP.sh

docker stop data01 data02 data03
docker rm data01 data02 data03

chmod ugo+x mongodbIP.sh
