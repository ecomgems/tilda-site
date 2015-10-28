###*
Express configuration
###

'use strict'

express = require 'express'
morgan = require 'morgan'
compression = require 'compression'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
cookieParser = require 'cookie-parser'
errorHandler = require 'errorhandler'
path = require 'path'
config = require './environment'

module.exports = (app) ->
  env = app.get('env')

  app.set 'views', config.root + '/server/views'
  app.engine 'html', require('ejs').renderFile
  app.set 'view engine', 'html'
  app.use compression()
  app.use bodyParser.urlencoded(extended: false)
  app.use bodyParser.json()
  app.use methodOverride()
  app.use cookieParser()

  # Force to use main host name
  # That's SEO Trick
  if 'production' is env
    forceDomain = require 'forcedomain'
    app.use forceDomain
      hostname: config.hostname
      type: 'permanent'
      protocol: false

  if 'production' is env
    app.use morgan('dev')

  if 'development' is env or 'test' is env
    app.use morgan('dev')
    app.use errorHandler() # Error handler - has to be last
