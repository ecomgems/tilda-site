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

Helper =

  ###
  # Upload files
  #
  # @param key is file pth on S3
  # @param buf is buffer with file
  ###
  upload: (key, buf)->

    def = Q.defer()

    s3obj = new AWS.S3
      params:
        Bucket: config.amazon.bucket
        'ContentType': mime.lookup key
        Key: key
        ACL: 'public-read'

    # TODO Invalidation request to CloudFront
    # TODO Upload file only if it was changed or missed on Cloud

    s3obj
    .upload Body: buf
    .send (err, data) ->
      if err
        def.reject err

      def.resolve data
      return

    def.promise



module.exports = Helper