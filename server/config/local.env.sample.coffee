'use strict'

# Use local.env.js for environment variables that grunt will set when the server starts locally.
# Use for your api keys, secrets, etc. This file should not be tracked by git.
#
# You will need to set these on the server you deploy to.

module.exports =
  DOMAIN:           'http://localhost:9000'
  HOSTNAME:         'localhost'
  SESSION_SECRET:   'tildasite-secret'

  # Control debug level for modules using visionmedia/debug
  DEBUG: ''

  SSL_KEY: 'path-to-key'
  SSL_CERT: 'path-to-cert'

  # Tilda Access Credentials
  TILDA_PROJECT_ID: 'project-id'
  TILDA_PUBLIC_KEY: 'public-key'
  TILDA_SECRET_KEY: 'secret-key'
  TILDA_404: '404'

  # Redis URI
  REDIS_URI: 'redis://localhost:6379'

  # Facebook
  FACEBOOK_APP_ID: 'facebook-app-id'

  # Google Analytics ID
  GOOGLE_ANALYTICS_ID: 'google-analytics-id'