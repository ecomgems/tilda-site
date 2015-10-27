'use strict'

_ = require 'lodash'

Page = require '../../api/page/page.model'
Project = require '../../api/project/project.model'

# Register Hook
# from Tilda
exports.hook = (req, res) ->

  pageId = req.query.pageid
  published = req.query.published

  # Send response
  res.status(200).send 'OK'

  Project
    .initProject()

    # Refresh
    # cached
    # values
    .then (project) ->

      Page.compile
        id: pageId
        published: published

    .then (page) ->
      console.log "Page #{page.title} was refreshed on Tilda" if page.title?
    .catch (err) ->
      console.error err

  return

handleError = (res, err) ->
  res.status(500).send err
