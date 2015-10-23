'use strict'

express = require 'express'
controller = require './hook.controller'
securityCheck = require '../../components/helpers/security'
projectCheck = require '../../components/helpers/project'

router = express.Router()

router.get '/', securityCheck, projectCheck, controller.hook


module.exports = router
