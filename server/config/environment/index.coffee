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

  hostname: process.env.HOSTNAME or 'hostname'

  # Root path of server
  root: path.normalize(__dirname + '/../../..')

  # Server port
  http_port: process.env.HTTP_PORT or 8080
  https_port: process.env.HTTPS_PORT or 8443

  # SSL Certificates
  ssl:
    key: process.env.SSL_KEY or './certs/server.key'
    cert: process.env.SSL_CERT or './certs/server.crt'

  # Should we populate the DB with sample data?
  seedDB: false

  # Secret for session, you will want to change this and make it an environment variable
  secrets:
    session: 'tilda-site-secret'

  redis:
    uri: process.env.REDIS_URI or 'redis://localhost:6379'

  # Tilda Access Credentials
  tilda:
    api:
      project_id: process.env.TILDA_PROJECT_ID or 'project-id'
      public_key: process.env.TILDA_PUBLIC_KEY or 'public-key'
      secret_key: process.env.TILDA_SECRET_KEY or 'secret-key'
    pages:
      no_document: process.env.TILDA_404 or '404'

  # Facebook App ID
  facebook:
    app_id: process.env.FACEBOOK_APP_ID or 'facebook-app-id'

  # Direct URL to Favicon
  favicon_url: process.env.FAVICON_URL or false

  # Google Analytics
  google:
    analytics:
      id: process.env.GOOGLE_ANALYTICS_ID or false

  # Access to Amazon
  # S3 and CloudFront
  amazon:
    key: process.env.AMAZON_API_KEY or 'key'
    secret: process.env.AMAZON_API_SECRET or 'secret'
    bucket: process.env.AMAZON_BUCKET or 'saas-contacts'
    region: process.env.AMAZON_REGION or 'us-east-1'
    cdn:
      domain: process.env.AMAZON_CDN_DOMAIN or 'cdn-domain'



# Export the config object based on the NODE_ENV
# ==============================================
module.exports = _.merge(all, require('./' + process.env.NODE_ENV) or {})
