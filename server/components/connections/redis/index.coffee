'use strict'

redis = require 'redis'
bluebird = require 'bluebird'

# Wrap Redis methods into promises
bluebird.promisifyAll(redis.RedisClient.prototype);
bluebird.promisifyAll(redis.Multi.prototype);

config = require '../../../config/environment'

# Create Redis client
client = redis.createClient config.redis.uri

client.on 'connect', () ->
  console.log "Connected to Redis"
  return

client.on 'error', (error) ->
  console.error error
  return

# Share Redis client
exports.module = client