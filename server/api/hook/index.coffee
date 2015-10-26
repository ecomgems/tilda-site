'use strict'

express = require 'express'
controller = require './hook.controller'
securityCheck = require '../../helpers/security'
projectCheck = require '../../helpers/project'

router = express.Router()

router.get '/', securityCheck, projectCheck, controller.hook


module.exports = router
