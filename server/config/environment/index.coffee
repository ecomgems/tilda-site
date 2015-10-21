'use strict'

path = require 'path'
_ = require 'lodash'

requiredProcessEnv = (name) ->
  throw new Error('You must set the ' + name + ' environment variable')  unless process.env[name]
  process.env[name]

# All configurations will extend these options
# ============================================
all =
  env: process.env.NODE_ENV

  # Root path of server
  root: path.normalize(__dirname + '/../../..')

  # Server port
  http_port: process.env.HTTP_PORT or 8080
  https_port: process.env.HTTPS_PORT or 8443

  # SSL Certificates
  ssl:
    key: process.env.SSL_KEY or 'path-to-key'
    cert: process.env.SSL_CERT or 'path-to-cert'

  # Should we populate the DB with sample data?
  seedDB: false

  # Secret for session, you will want to change this and make it an environment variable
  secrets:
    session: 'tilda-site-secret'

  # MongoDB connection options
  mongo:
    options:
      db:
        safe: true





# Export the config object based on the NODE_ENV
# ==============================================
module.exports = _.merge(all, require('./' + process.env.NODE_ENV) or {})
