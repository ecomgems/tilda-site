###
# Tilda API helper
###

'use strict'

Q = require 'q'
fetch = require 'node-fetch'

class Tilda
  constructor: (@public_key, @secret_key) ->

  _fetch: (url) ->
    deferred = Q.defer()

    fetch(url)
    .then (res)->
      res.json()
    .then (data) ->
      if data.status is 'FOUND'
        deferred.resolve data.result
      else
        deferred.reject data.message

    deferred.promise

  project: (projectId) ->
    url = "http://api.tildacdn.info/v1/getproject/?publickey=#{@public_key}&secretkey=#{@secret_key}&projectid=#{projectId}"
    @_fetch url

  # List of pages
  pages: (projectId) ->
    url = "http://api.tildacdn.info/v1/getpageslist/?publickey=#{@public_key}&secretkey=#{@secret_key}&projectid=#{projectId}"
    @_fetch url


  # Page with HTML
  page: (pageId) ->
    url = "http://api.tildacdn.info/v1/getpage/?publickey=#{@public_key}&secretkey=#{@secret_key}&pageid=#{pageId}"
    @_fetch url


exports = module.exports = Tilda

