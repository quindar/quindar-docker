. ./mongodbIP.sh

docker stop data01 data02 data03
docker rm data01 data02 data03

docker run -p 3101:27017 --name data01 --hostname data01.audacy.space -d -v /mnt/data/data01:/data/db -v /mnt/data/docker/mongodb/keyfile:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M edgarzlin/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01" --auth

docker run -p 3102:27017 --name data02 --hostname data02.audacy.space -d -v /mnt/data/data02:/data/db -v /mnt/data/docker/mongodb/keyfile:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M edgarzlin/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01" --auth

docker run -p 3103:27017 --name data03 --hostname data03.audacy.space -d -v /mnt/mq/data03:/data/db -v /mnt/data/docker/mongodb/keyfile:/opt/keyfile --add-host data01.audacy.space:${DATA01} --add-host data02.audacy.space:${DATA02} --add-host data03.audacy.space:${DATA03} --memory 4000M edgarzlin/mongodb --keyFile /opt/keyfile/mongodb-keyfile --replSet "audacy01" --auth

docker exec -i data01 bash << leftcurlybracket
mongo -u XXX -p XXX --authenticationDatabase admin
  use admin
  db.auth("XXX","XXX")
  rs.add("data02.audacy.space:27017")
  if(!rs.isMaster().ismaster){
    print("Is no longer primary after adding data02. Please add remaining nodes by hand")
    exit
  }
  rs.add("data03.audacy.space:27017")
exit
leftcurlybracket


