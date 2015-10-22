'use strict'

redis = require 'redis'
config = require '../../../config/environment'

client = redis.createClient config.redis.uri

client.on 'connect', () ->
  console.log "Connected to Redis ヽ(^ᴗ^)丿"
  return

client.on 'error', (error) ->
  console.error error
  return

exports.module = client