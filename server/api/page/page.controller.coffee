'use strict'

_ = require 'lodash'

# Register Hook
# from Tilda
exports.get = (req, res) ->

  console.log req.params

  # TODO Get

  res.status(200).send 'ヽ(^ᴗ^)丿'
  return




handleError = (res, err) ->
  res.status(500).send err
