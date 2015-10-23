'use strict'

_ = require 'lodash'
Page = require './page.model'
config = require '../../config/environment'

Promises = require 'bluebird'

# Register Hook
# from Tilda
exports.get = (req, res) ->

  _path = if req.params.path? then req.params.path else ''
  Page
  .getHtml(_path)
  .then (html) ->
    if html

      res.status(200).send html

    else

      Page
        .getHtml config.tilda.pages.no_document
        .then (html404) ->
          res.status(404).send html404

    return

  .catch (err) ->
      handleError(res, err)

  return


handleError = (res, err) ->
  res.status(500).send err
