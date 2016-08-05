docker exec -i  data01 bash << leftcurlybracket
mongo
  use admin
  // rs.initiate()
  db.createUser( { user: "admin", pwd: "password", roles: [ { role: "userAdminAnyDatabase", db: "admin" }, { role: "clusterAdmin", db: "admin" }, { role: "dbAdminAnyDatabase", db: "admin" } ] } )
  db.auth("admin","password")
  db.createUser( { user: "ray", pwd: "password", roles: [ { role: "root", db: "admin" } ] });
  db.createUser( { user: "edgar", pwd: "password", roles: [ { role: "root", db: "admin" } ] });
  db.createUser( { user: "audacy", pwd: "password", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] } )
  db.createUser( { user: "audacyapp", pwd: "password", roles: [ "readWriteAnyDatabase" ] } );
exit
leftcurlybracket

