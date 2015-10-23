'use strict'

Q = require 'q'

config = require '../../config/environment'
redis = require '../../components/helpers/redis'

Tilda = require '../../components/helpers/tilda'
tilda = new Tilda config.tilda.api.public_key, config.tilda.api.secret_key

Project = require '../project/project.model'

Promises = require 'bluebird'

md5 = require 'md5'

class Page

  @_get = (key) ->

    def = Q.defer()

    redis
    .getAsync key
    .then (value) ->
      def.resolve value
      return
    .catch (err) ->
      def.reject err
      return

    def.promise

  @_set = (key, value) ->

    def = Q.defer()

    redis
    .setAsync key, value
    .then (value) ->
      def.resolve value
      return
    .catch (err) ->
      def.reject err
      return

    def.promise


  ###
  # Check if page
  # is still fresh
  ###
  @isPageFresh = (id, published) ->

    def = Q.defer()

    @getPublished(id)
    .then (value) ->
      if not value? or value < published
        def.resolve false
      else
        def.resolve true

    def.promise

  @setPublished = (id, published) ->
    key = "published_#{id}"
    @_set key, published

  @getPublished = (id) ->
    key = "published_#{id}"
    @_get key

  @setHtml = (path, html) ->
    key = "page_#{md5(path)}"
    @_set key, html

  @getHtml = (path) ->
    key = "page_#{md5(path)}"
    @_get key

  @compile = (page) ->

    def = Q.defer()

    _page = page

    # Validate if
    # we need to
    # recompile
    # the page
    @isPageFresh page.id, page.published
    .then (isFresh) ->

      if isFresh
        # Return page
        # and cancel
        # the chain
        def.resolve page
        return Promises.cancel()

      else

        # Fetch complete
        # page data from
        # Tilda
        return tilda.page page.id

    .then (page) ->

      _page = page
      Page.setHtml _page.alias, _page.html

    .then () ->
      Page.setPublished _page.id, _page.published

    .catch (err) ->
      def.reject err

    def.promise


  @initPages = (project) ->

    console.log "Prepare Tilda Pages for #{project.title} project"
    def = Q.defer()

    tilda
      # Fetch info
      # about all pages
      # in the project
      .pages project.id

      # Compile all pages
      # we need to compile
      .then (pages) =>

        promises = []

        for page in pages
          promises.push @compile page

        Promises.app promises

      # Resolve promise
      # to initialize
      # pages
      .then (pages) ->
        def.resolve pages

      # Sure try
      # to handle
      # any problems
      .catch (err) ->
        def.reject err
        return

    def.promise

  @prepareHtml = (page)->





module.exports = Page