'use strict'


Q = require 'q'
mongoose = require 'mongoose'
config = require '../../config/environment'

console.log config

Tilda = require '../../components/helpers/tilda'
tilda = new Tilda config.tilda.api.public_key, config.tilda.api.secret_key


Schema = mongoose.Schema

# Instantiate new Schema
PageSchema = new Schema
  name: String
  info: String
  active: Boolean

# Empty project object
# to be filled on start
project = false


PageSchema.statics.initProject = () ->
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


PageSchema.statics.initPages = (project) ->
  console.log "Prepare Tilda Pages for #{project.title}"
  deferred = Q.defer()


  deferred.promise



  return

module.exports = mongoose.model 'Page', PageSchema