'use strict'

express = require 'express'
controller = require './hook.controller'

router = express.Router()

router.get '/', controller.hook


module.exports = router
