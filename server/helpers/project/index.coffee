'use strict'

config = require '../../config/environment'

module.exports = (req, res, next) ->

  if not req.query.projectid? or req.query.projectid isnt config.tilda.api.project_id
    res.status(404).send("Project ID is wrong.")
    return

  next()