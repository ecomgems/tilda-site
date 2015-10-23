###*
Main application routes
###

'use strict'

module.exports = (app) ->

  # Insert routes below
  app.use '/api/hook', require './api/hook'
  app.use '/', require './api/page'
