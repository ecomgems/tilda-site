'use strict'

Q = require 'q'
redisClient = require '../../components/connections/redis'

config = require '../../config/environment'

Tilda = require '../../components/helpers/tilda'
tilda = new Tilda config.tilda.api.public_key, config.tilda.api.secret_key

Promise = require 'bluebird'

class Page

  @project = false

  @initProject = () ->
    console.log "Prepare Tilda Project"
    deferred = Q.defer()

    tilda
      .project config.tilda.api.project_id
      .then (project) ->

        promises = []

        for key, value of project
          if typeof value is 'string'
            promises.push redisClient.setAsync 'project_title', project


          console.log key
          console.log value
          console.log typeof value


        Promise.all promises



      .then (result) ->

        console.log result

        deferred.resolve @project

      .catch (err) ->

        deferred.reject err
        return

    deferred.promise

  @initPages = (project) ->
    console.log "Prepare Tilda Pages for #{project.title}"
    deferred = Q.defer()

    # TODO Something

    deferred.promise

module.exports = Page