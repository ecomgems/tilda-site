###*
Main application routes
###

'use strict'

errors = require './components/errors'

module.exports = (app) ->

  # Insert routes below
  app.use '/api/hook', require './api/hook'

  app.get '/', (req, res) ->
    res.status(200).send 'ヽ(^ᴗ^)丿'
    return



  # All undefined asset or api routes should return a 404
  app.route('/*').get errors[404]
