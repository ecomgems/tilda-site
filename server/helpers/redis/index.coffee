###
# Tilda API helper
###

'use strict'

config = require '../../config/environment'
redis = require 'redis'

Promise = require 'bluebird'
Promise.promisifyAll(redis.RedisClient.prototype);
Promise.promisifyAll(redis.Multi.prototype);

client = redis.createClient config.redis.uri
console.log "Connected to redis on #{config.redis.uri}"


exports = module.exports = client
