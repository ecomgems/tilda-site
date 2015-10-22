###*
Main application routes
###

'use strict'

errors = require './components/errors'

module.exports = (app) ->

  # Insert routes below
  app.use '/api/hook', require './api/hook'

  # Insert routes below
  app.use '/', require './api/page'



  # All undefined asset or api routes should return a 404
  app.route('/*').get errors[404]
