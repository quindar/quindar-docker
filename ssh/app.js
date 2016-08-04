var express = require('express');

var server = express();
server.use(express.static(__dirname + '/'));

var port = 8080;
server.get('/', function (req, res) {
   res.send('Welcome to NodeJS Web Server!\n');
});
server.listen(port, function() {
   console.log('NodeJS Web server listening on port ' + port);
});
