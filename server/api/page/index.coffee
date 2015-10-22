'use strict'

express = require 'express'
controller = require './page.controller'

router = express.Router()

router.get '/', controller.get
router.get '/:id', controller.get


module.exports = router
