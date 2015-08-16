var express = require('express');
var webpackDevMiddleware = require("webpack-dev-middleware");
var webpack = require("webpack");

var port = parseInt(process.argv[2], 10);
var configFile = process.argv[3];
var silent = process.argv[4] == "true";

var app = express();
var config = require(configFile);
var compiler = webpack(config);

app.use(webpackDevMiddleware(compiler, { lazy: true, noInfo: silent }));

var server = app.listen(port, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log('webpack-rails server is listening at http://%s:%s', host, port);
});
