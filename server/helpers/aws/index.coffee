###
# AWS Helper
###

'use strict'

Q = require 'q'
mime = require 'mime'
config = require '../../config/environment'

AWS = require 'aws-sdk'
AWS.config.region = config.amazon.region
AWS.config.accessKeyId = config.amazon.key
AWS.config.secretAccessKey = config.amazon.secret

S3obj = new AWS.S3
  params:
    Bucket: config.amazon.bucket

class AWSHelper

  ###
  # Upload files
  #
  # @param key is file pth on S3
  # @param buf is buffer with file
  ###
  @upload = (key, content)->

    def = Q.defer()

    S3obj
    .upload
      Body: content
      'ContentType': mime.lookup key
      Key: key
      ACL: 'public-read'

    .send (err, data) ->

      if err
        def.reject err

      def.resolve data
      return

    def.promise


  @delete = (key) ->

    def = Q.defer()

    S3obj.deleteObject Key: key, (err, data) ->
      if err
        def.reject err
        return

      def.resolve data
      return

    def.promise



module.exports = AWSHelper