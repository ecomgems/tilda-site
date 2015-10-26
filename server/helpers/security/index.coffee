'use strict'

config = require '../../config/environment'

module.exports = (req, res, next) ->

  if not req.query.publickey? or req.query.publickey isnt config.tilda.api.public_key
    res.status(401).send("Public key is wrong.")
    return

  next()