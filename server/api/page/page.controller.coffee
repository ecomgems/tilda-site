'use strict'

_ = require 'lodash'
redis = require '../../components/connections/redis'


# Register Hook
# from Tilda
exports.get = (req, res) ->

  console.log req.params

  # TODO Get

  res.status(200).send 'ヽ(^ᴗ^)丿'
  return



handleError = (res, err) ->
  res.status(500).send err
