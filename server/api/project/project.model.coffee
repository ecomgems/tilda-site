'use strict'

Q = require 'q'

config = require '../../config/environment'
redis = require '../../components/helpers/redis'

Tilda = require '../../components/helpers/tilda'
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

    projectJson = JSON.stringify(project)
    redis
      .setAsync 'project', projectJson
      .then () ->
        def.resolve project
        return
      .catch (err) ->
        def.reject err
        return

    def.promise


module.exports = Project