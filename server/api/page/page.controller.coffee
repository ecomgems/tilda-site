'use strict'

_ = require 'lodash'

Page = require './page.model'

# Register Hook
# from Tilda
exports.get = (req, res) ->

  _path = if req.params.path? then req.params.path else ''
  Page
    .getHtml(_path)
    .then (html) ->
      res.status(200).send html
    .catch (err) ->
      handleError(res, err)

  return


handleError = (res, err) ->
  res.status(500).send err
