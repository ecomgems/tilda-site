###*
Using Rails-like standard naming convention for endpoints.
GET     /things              ->  index
POST    /things              ->  create
GET     /things/:id          ->  show
PUT     /things/:id          ->  update
DELETE  /things/:id          ->  destroy
###

'use strict'

_ = require 'lodash'
Thing = require './thing.model'

# Get list of things
exports.index = (req, res) ->
  Thing.find (err, things) ->
    return handleError(res, err)  if err
    res.status(200).json things
  


# Get a single thing
exports.show = (req, res) ->
  Thing.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless thing
    res.json thing

# Creates a new thing in the DB.
exports.create = (req, res) ->
  Thing.create req.body, (err, thing) ->
    return handleError(res, err)  if err
    res.status(201).json thing

# Updates an existing thing in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Thing.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless thing
    updated = _.merge(thing, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json thing

# Deletes a thing from the DB.
exports.destroy = (req, res) ->
  Thing.findById req.params.id, (err, thing) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless thing
    thing.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
