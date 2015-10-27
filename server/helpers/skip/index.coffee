'use strict'

Q = require 'q'
module.exports = (value) ->
  def = Q.defer()
  def.resolve value
  def.promise
