###*
Main application file
###
'use strict'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

fs = require 'fs'
express = require 'express'
mongoose = require 'mongoose'
config = require './config/environment'

# Connect to database
mongoose.connect config.mongo.uri, config.mongo.options

mongoose.connection.on 'error', (err) ->
  console.error "MongoDB connection error: #{err}"
  process.exit -1

# Populate DB with sample data
require './config/seed'  if config.seedDB

# Setup HTTP and HTTPS servers
app = express()

options =
  key: fs.readFileSync(config.ssl.key).toString()
  cert: fs.readFileSync(config.ssl.cert).toString()

httpServer = require('http').createServer app
httpsServer = require('https').createServer options, app

require('./config/express') app
require('./routes') app

# Start HTTP server
httpServer.listen config.http_port, ->
  console.log 'Express HTTP server listening on %d, in %s mode', config.http_port, app.get('env')

# Start HTTPS server
httpsServer.listen config.https_port, ->
  console.log 'Express HTTPS server listening on %d, in %s mode', config.https_port, app.get('env')

# Expose app
exports = module.exports = app