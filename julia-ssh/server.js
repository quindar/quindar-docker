// Program:  server.js
// Purpose:  Quindar-platform NodeJS server startup scripts
// Author:   Ray Lai
// Updated:  May 25, 2016
// License:  MIT license
//
var express = require('express');

var server = express();
server.use(express.static(__dirname + '/'));

var port = process.env.PORT  || 3000;
server.get('/', function (req, res) {
   res.send('Welcome to NodeJS Web Server!\n');
});
server.listen(port, function() {
   console.log('NodeJS Web server listening on port ' + port);
});
