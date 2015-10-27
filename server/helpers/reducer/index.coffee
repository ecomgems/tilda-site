###
# This helper:
#
# 1. Reduce quantity of
#    requests to S3
#
# 2. Guarantee that cached
#    files are always fresh
###

'use strict'

redis= require '../redis'
Q = require 'q'
md5 = require 'md5'
path = require 'path'

awsHelper = require '../aws'
Skip = require '../skip'

class Reducer

  @getRedisKey = (key)->
    "file_#{md5(key)}"

  @getAmazonKey = (key, hash)->
    ext = path.extname(key)
    regex = new RegExp("#{ext}$", 'i')
    key.replace regex, "/#{hash}#{ext}"

  @getExpiredHash = (key, hash) ->

    def = Q.defer()

    cacheKey = Reducer.getRedisKey(key)
    redis
      .getAsync cacheKey
      .then (value) ->

        value = false if not value
        value = false if value is hash

        def.resolve value

      .catch (err)->
        def.reject err

    def.promise


  @isMissed = (key) ->
    def = Q.defer()

    cacheKey = Reducer.getRedisKey(key)
    redis
    .getAsync cacheKey
    .then (value) ->

      if value
        def.resolve false
      else
        def.resolve true

    .catch (err)->
      def.reject err

    def.promise


  @upload = (key, content) ->
    def = Q.defer()

    hash = md5(content)
    amazonKey = Reducer.getAmazonKey key, hash
    Reducer
      # Check if we cached
      # this content before
      .getExpiredHash(key, hash)
      .then (expiredHash)->

        if expiredHash
          expiredKey = Reducer.getAmazonKey(key, expiredHash)
          console.log "Delete expired #{key} from cloud."
          awsHelper.delete(expiredKey)
        else
          Reducer.isMissed key

      .then (needToUpload) ->

        if needToUpload
          console.log "Upload new #{key} to the cloud."
          awsHelper.upload amazonKey, content
        else
          Skip()

      .then ->
        cacheKey = Reducer.getRedisKey(key)
        redis.setAsync cacheKey, hash

      .then () ->
        def.resolve amazonKey

      .catch (err) ->
        def.reject err

    def.promise



module.exports = Reducer