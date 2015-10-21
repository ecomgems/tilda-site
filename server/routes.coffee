###*
Main application routes
###

'use strict'

errors = require './components/errors'

module.exports = (app) ->




  # All undefined asset or api routes should return a 404
  app.route('/*').get errors[404]
