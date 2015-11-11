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
awsReducer = require '../reducer'
Promises = require 'bluebird'
request = require 'request-promise'
path = require 'path'
config = require '../../config/environment'
urlRegex = require 'url-regex'
urlPattern = require 'url-pattern'
Skip = require '../skip'

mime = require 'mime'

tildaImages = new urlPattern '(:protocol\\://)(:subdomain.):domain.:tld(/*)'

class CDNify


  @exchange = (url)->

    def = Q.defer()

    _cdnKey = null

    request(url)
      .then (content) ->

        # Content might
        # be really empty
        # So then skip it
        if content.length and path.extname(url) in ['.css', '.js']

          CDNify.content(content)
        else

          # Skip this chain
          Skip(content)

      .then (content) ->

        if content.length
          _cdnKey = url.replace('http://tilda.ws/', '')
          awsReducer.upload _cdnKey, content
        else
          Skip(null)

      .then (key) ->
        if key
          def.resolve "//#{config.amazon.cdn.domain}/#{key}"
        else
          def.resolve null
        return

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

        # Filter files what
        # never been uploaded
        # because these are empty
        cdnUrls = _.filter cdnUrls, (value) ->
          value isnt null

        def.resolve niceUrls.concat(cdnUrls)
        return
      .catch (err)->
        def.reject err

    def.promise

  @content = (content) ->

    def = Q.defer()

    # Fix Tilda CDN URLs
    content =
      content
      .replace /http:\/\/images\.tildacdn\.info\//gi, '//images.tildacdn.info/'


    # Get all URLs from content
    urls = content.match urlRegex()
    urls = [] if not urls?

    urls = _.unique urls

    urls = _.map urls, (url) ->
      url
        .replace /"/g, ''
        .replace /\'/g, ''
        .replace /\\'/g, ''
        .replace /\(/g, ''
        .replace /\)/g, ''


    urls = _.filter urls, (url) ->
      match = tildaImages.match url

      if match?

        correctProtocol = match.protocol? and match.tld is 'http'
        correctDomain = match.domain? and match.domain is 'tilda'
        correctTld = match.tld? and match.tld is 'ws'

        correctProtocol and correctDomain and correctTld

      else

        false

    promises = []

    for url in urls
      promises.push CDNify.exchange(url)

    Promises
      .all promises
      .then (cdnUrls) ->

        for url, i in urls
          content = content.replace url, cdnUrls[i]
          content = content.replace url, cdnUrls[i]

        def.resolve content

        return

      .catch (err) ->
        def.reject err


    def.promise



module.exports = CDNify