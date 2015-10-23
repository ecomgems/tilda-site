'use strict'

Q = require 'q'

config = require '../../config/environment'
redis = require '../../components/helpers/redis'

Tilda = require '../../components/helpers/tilda'
tilda = new Tilda config.tilda.api.public_key, config.tilda.api.secret_key

Project = require '../project/project.model'

Promises = require 'bluebird'

md5 = require 'md5'
liquid = require 'liquid-node'

fs = require 'fs'
Promises.promisifyAll(fs)

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

    Page.getPublished(id)
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

  @setHtml = (path, html, protocol = 'http') ->
    key = "#{protocol}_#{md5(path)}"
    @_set key, html

  @getHtml = (path, protocol = 'http') ->
    key = "#{protocol}_#{md5(path)}"
    @_get key

  ###
  # Compile page
  # if that's necessary
  # to recompile it
  ###
  @compile = (page) ->

    def = Q.defer()

    _page = null

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

      # Prepare content
      # for both HTTP and
      # HTTPS protocols
      Promises.all [
        Page.prepareHtml(page, 'http'),
        Page.prepareHtml(page, 'https')
      ]

    .then (contents) ->

      httpContent = contents[0]
      httpsContent = contents[1]

      Promises.all [
        Page.setHtml(_page.alias, httpContent, 'http')
        Page.setHtml(_page.alias, httpsContent, 'https')
      ]

    .then () ->

      Page.setPublished _page.id, _page.published

    .then () ->
      def.resolve _page

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
          promises.push Page.compile page

        Promises.all promises

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

  @prepareHtml = (page, protocol = 'http')->

    def = Q.defer()

    templatePath = './template/page.liquid'
    fetchPartsPromises = [
      fs.readFileAsync(templatePath, 'utf8')
      Project.get(config.tilda.api.project_id)
    ]

    Promises
    .all fetchPartsPromises
    .then (parts) ->

      content = parts[0]
      project = parts[1]

      engine = new liquid.Engine
      return engine.parseAndRender content,
        page: page
        config: config
        protocol: protocol
        project: project

    .then (html) ->

      def.resolve html
      return

    .catch (err) ->
      def.reject err
      return

    def.promise


module.exports = Page
