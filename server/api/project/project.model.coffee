'use strict'

Q = require 'q'

config = require '../../config/environment'
redis = require '../../helpers/redis'
CDNify = require '../../helpers/cdnify'

Tilda = require '../../helpers/tilda'
tilda = new Tilda config.tilda.api.public_key, config.tilda.api.secret_key

class Project

  ###
  # Init Project in the
  ###
  @initProject = () ->
    console.log "Prepare Tilda Project"

    deferred = Q.defer()

    tilda
      # Fetch fresh
      # project data
      # from Tilda
      .project config.tilda.api.project_id

      # Then store
      # it into memory
      # storage
      .then (project) ->
        Project.set project

      # Resolve promise ヽ(^ᴗ^)丿
      .then (project) ->
        deferred.resolve project

      # Sure try
      # to handle
      # any problems
      .catch (err) ->
        deferred.reject err
        return

    deferred.promise

  @get = () ->
    def = Q.defer()

    redis
    .getAsync 'project'
    .then (projectJson) ->

      project = JSON.parse(projectJson)
      def.resolve project

      return

    .catch (err) ->
      def.reject err
      return

    def.promise

  @set = (project) ->

    def = Q.defer()

    _project = project
    CDNify
      .list(_project.js)
      .then (jsList)->

        console.log "JS:", jsList

        _project.js = jsList
        CDNify.list(_project.css)

      .then (cssList)->

        console.log "CSS:", cssList

        _project.css = cssList
        projectJson = JSON.stringify(_project)
        redis.setAsync 'project', projectJson

      .then () ->

        def.resolve _project
        return

      .catch (err) ->

        def.reject err
        return

    def.promise


module.exports = Project
