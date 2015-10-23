'use strict'

_ = require 'lodash'

# Register Hook
# from Tilda
exports.hook = (req, res) ->

  console.log req.query

  # TODO Get

  res.status(200).json 'OK ヽ(^ᴗ^)丿'
  return



handleError = (res, err) ->
  res.status(500).send err
