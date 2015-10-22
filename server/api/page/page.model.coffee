'use strict'

Q = require 'q'
redis = require '../../components/connections/redis'

config = require '../../config/environment'

Tilda = require '../../components/helpers/tilda'
tilda = new Tilda config.tilda.api.public_key, config.tilda.api.secret_key

class Page

  @project = false

  @initProject = () ->
    console.log "Prepare Tilda Project"
    deferred = Q.defer()

    tilda
    .project config.tilda.api.project_id
    .then (project) ->

      deferred.resolve project
      project
    .then (project) ->

      console.log project


    .catch (err) ->
      deferred.reject err
      return

    deferred.promise

  @initPages = (project) ->
    console.log "Prepare Tilda Pages for #{project.title}"
    deferred = Q.defer()

    # TODO Something

    deferred.promise

    return

module.exports = Page