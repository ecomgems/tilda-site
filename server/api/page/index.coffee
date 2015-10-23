'use strict'

express = require 'express'
controller = require './page.controller'

router = express.Router()

router.get '/', controller.get
router.get '/:path', controller.get


module.exports = router
