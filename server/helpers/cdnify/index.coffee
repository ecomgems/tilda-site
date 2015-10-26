###
# We want to exchange
# any file insecure
# URL to fast and
# secure CDN URL
# on Amazon Cloud
#
# All urls that starts
# from "http://tilda.ws"
# are qualified as
# insecure and slow
###

'use strict'

_ = require 'lodash'
Q = require 'q'
awsHelper = require '../aws'
Promises = require 'bluebird'
request = require 'request-promise'
path = require 'path'
config = require '../../config/environment'

class CDNify


  @exchange = (url)->

    def = Q.defer()

    _cdnKey = null

    request(url)
      .then (content)->

        _cdnKey = url.replace('http://tilda.ws/', '')
        awsHelper.upload _cdnKey, content

      .then (data) ->

        console.log ("#{_cdnKey} was uploaded to Amazon")
        def.resolve "//#{config.amazon.cdn.domain}/#{_cdnKey}"

      .catch (err) ->
        def.reject err

    def.promise


  ###
  # It will get a list of URLs,
  # download it and upload to
  # the cloud.
  # The result will be list
  # of CDNified URLs.
  ###
  @list = (list) ->
    def = Q.defer()

    # Filter list of URLs
    # that should be processed
    cdnifyUrls = _.filter list, (url)->
      url.match /^http:\/\/tilda.ws/i

    # Filter list of URLs
    # to just fix protocol
    fixProtocolUrls = _.filter list, (url)->
      not url.match /^http:\/\/tilda.ws/i

    niceUrls = _.map fixProtocolUrls, (url)->
      url
        .replace "http://", "//"
        .replace "https://", "//"

    promises = []
    for url in cdnifyUrls
      promises.push CDNify.exchange url

    Promises
      .all promises
      .then (cdnUrls)->
        def.resolve niceUrls.concat(cdnUrls)
        return
      .catch (err)->
        def.reject err

    def.promise

  @content = (content) ->

    def = Q.defer()






    def.promise



module.exports = CDNify