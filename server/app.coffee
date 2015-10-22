###*
Main application file
###
'use strict'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

fs = require 'fs'
express = require 'express'
config = require './config/environment'



# Populate DB with sample data
require './config/seed'  if config.seedDB

# Init pages on fly
Page = require './api/page/page.model'
Page
.initProject()
.then (project) ->
  Page.initPages(project)
.catch (err)->
  console.error err
  return


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
