Setting up MongoDB replica set on docker host
Updated: Jul 8, 2016

## Credentials
* As per team discussion on 7/8/2016, we will create different passwords for test server, staging and
 production servers, but stop using 'race2space' as password.
* For test server, we can continue to use id=audacy, password=quindar
* For production server, we can use id=audacyapp, password=quindar2016#

On data05:
audacy01:PRIMARY> db.createUser( { user: "audacyapp", pwd: "quindar2016", roles: [ { role: "root", db: "admin" } ] });

if you want to change user password, try
db.updateUser("audacyapp", { pwd: "quindar2016#" })

## Steps
1. ssh data04.audacy.space

2. cd /mnt/data/docker/mongodb
create subfolder keyfiles: /mnt/data/docker/mongodb/keyfiles

touch mongodb-keyfile
chmod ugo+w mongodb-keyfile
root@node*:/# openssl rand -base64 741 > mongodb-keyfile
root@node*:/# chmod 600 mongodb-keyfile
root@node*:/# sudo chown 999 mongodb-keyfile

3. create mongodb data volumes for each docker container
cd /mnt/data
sudo mkdir /mnt/data/staging
sudo mkdir /mnt/data/staging/data01
sudo mkdir /mnt/data/staging/data02
sudo mkdir /mnt/data/staging/data03

4. find 3 IP addresses for MongoDB
sudo ./createMongoDBip.sh
. ./mongodbIP.sh

5. create mongodb docker containers

sudo docker run -p 3101:27017 --name data01 --hostname data01.audacy.space -d -v /mnt/data/staging/data01:/data/db -v /mnt/data/docker/mongodb/core:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01"

sudo docker run -p 3102:27017 --name data02 --hostname data02.audacy.space -d -v /mnt/data/staging/data02:/data/db -v /mnt/data/docker/mongodb/core:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01"

sudo docker run -p 3103:27017 --name data03 --hostname data03.audacy.space -d -v /mnt/data/staging/data03:/data/db -v /mnt/data/docker/mongodb/core:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01"

6. set up mongodb cluster
%sudo docker exec -ti data01 bash
%mongo
>

then initiate replica set and create  admin user id
>rs.initiate()
>use admin
>db.createUser( { user: "ray", pwd: "race2space", roles: [ { role: "root", db: "admin" } ] });
>db.createUser( { user: "admin", pwd: "race2space", roles: [ { role: "userAdminAnyDatabase", db: "admin" }, { role: "clusterAdmin", db: "admin" }, { role: "dbAdminAnyDatabase", db: "admin" } ] } )
>db.createUser( { user: "audacy", pwd: "race2space", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] } )

>show users

then restart mongodb with auth option "--auth", e.g.


when you see the prompt 
audacy01:PRIMARY>

you should login to mongodb using the previous credentials, e.g.

>use admdin
>db.auth('ray','race2space')



7. restart mongodb with --auth option

sudo docker stop data01 data02 data03
sudo docker rm data01 data02 data03

sudo docker run -p 3101:27017 --name data01 --hostname data01.audacy.space -d -v /mnt/data/staging/data01:/data/db -v /mnt/data/docker/mongodb/core:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01" --auth

sudo docker run -p 3102:27017 --name data02 --hostname data02.audacy.space -d -v /mnt/data/staging/data02:/data/db -v /mnt/data/docker/mongodb/core:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01" --auth

sudo docker run -p 3103:27017 --name data03 --hostname data03.audacy.space -d -v /mnt/data/staging/data03:/data/db -v /mnt/data/docker/mongodb/core:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M rayymlai/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01" --auth

repeat login and db auth, e.g.

%mongo
audacy01:PRIMARY> use admin
switched to db admin
audacy01:PRIMARY> db.auth('ray','race2space')
1

8. manual add replica set members

audacy01:PRIMARY> rs.status()
{
	"set" : "audacy01",
	"date" : ISODate("2016-06-28T00:16:27.357Z"),
	"myState" : 1,
	"term" : NumberLong(2),
	"heartbeatIntervalMillis" : NumberLong(2000),
	"members" : [
		{
			"_id" : 0,
			"name" : "data01.audacy.space:27017",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			"uptime" : 80,
			"optime" : {
				"ts" : Timestamp(1467072910, 1),
				"t" : NumberLong(2)
			},
			"optimeDate" : ISODate("2016-06-28T00:15:10Z"),
			"infoMessage" : "could not find member to sync from",
			"electionTime" : Timestamp(1467072909, 1),
			"electionDate" : ISODate("2016-06-28T00:15:09Z"),
			"configVersion" : 1,
			"self" : true
		}
	],
	"ok" : 1
}
audacy01:PRIMARY> rs.add('data02.audacy.space:27017')
{ "ok" : 1 }
audacy01:PRIMARY> rs.add('data03.audacy.space:27017')
{ "ok" : 1 }

9. in case your primary node becomes secondary node unexpectedly, and you need to force secondary to primary node.
* shut down unused or other nodes
* run these steps

>cfg = rs.config()
>cfg.members = [cfg.members[0]]
>rs.reconfig(cfg, {force: true})


## Transcript

[ray@data04 keyfiles]$ sudo touch mongodb-keyfile
[ray@data04 keyfiles]$ sudo chmod ugo+w mongodb-keyfile 
[ray@data04 keyfiles]$ sudo openssl rand -base64 741 > mongodb-keyfile
[ray@data04 keyfiles]$ sudo chmod 600 mongodb-keyfile
[ray@data04 keyfiles]$ sudo sudo chown 999 mongodb-keyfile

[ray@data04 mongodb]$ sudo chmod ugo+x createMongoDBip.sh 
[ray@data04 mongodb]$ sudo chmod ugo+x mongodbIP.sh 


## Reference
https://medium.com/@gargar454/deploy-a-mongodb-cluster-in-steps-9-using-docker-49205e231319#.oah61g53j


## Source codes

### createMongoDBIP.sh
this file will create temporary mongodb docker containers and extract IP addresses. upon completion, it will remove docker containers. it will output a file "mongodbIP.sh" so that you can set env variables for the next job to create replica set.

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
        rm mongodbIP.sh
fi

echo "...extracting data01 IP address"
docker run -p 11001:27017 --name data01 --hostname data01.audacy.space -d -v /mnt/data/staging/data01:/data/db rayymlai/mongodb

X=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' data01`
export DATA01=$X
echo "export DATA01="$DATA01 >> mongodbIP.sh

echo "...extracting data02 IP address"
docker run -p 11002:27017 --name data02 --hostname data02.audacy.space -d -v /mnt/data/staging/data02:/data/db rayymlai/mongodb

X=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' data02`
export DATA02=$X
echo "export DATA02="$DATA02 >> mongodbIP.sh

echo "...extracting data03 IP address"
docker run -p 11003:27017 --name data03 --hostname data03.audacy.space -d -v /mnt/data/staging/data03:/data/db rayymlai/mongodb

X=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' data03`
export DATA03=$X
echo "export DATA03="$DATA03 >> mongodbIP.sh

docker stop data01 data02 data03
docker rm data01 data02 data03

