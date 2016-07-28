docker exec -i  data01 bash << leftcurlybracket
mongo
  use admin
  rs.initiate()
  db.createUser( { user: "XXX", pwd: "XXX", roles: [ { role: "userAdminAnyDatabase", db: "admin" }, { role: "clusterAdmin", db: "admin" }, { role: "dbAdminAnyDatabase", db: "admin" } ] } )
  db.auth("XXX","XXX")
  db.createUser( { user: "XXX", pwd: "XXX", roles: [ { role: "root", db: "admin" } ] });
  db.createUser( { user: "XXX", pwd: "XXX", roles: [ { role: "root", db: "admin" } ] });
  db.createUser( { user: "XXX", pwd: "XXX", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] } )
exit
leftcurlybracket

