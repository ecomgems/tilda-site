'use strict'

_ = require 'lodash'

# Register Hook
# from Tilda
exports.hook = (req, res) ->

  console.log req.params

  # TODO Get

  res.status(200).json 'ヽ(^ᴗ^)丿'
  return



handleError = (res, err) ->
  res.status(500).send err
