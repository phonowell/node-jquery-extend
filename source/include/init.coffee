module.exports = ($$) ->

  # require

  $ = require('node-jquery-lite')()

  axios = require 'axios'
  qs = require 'qs'

  Promise = require 'bluebird'
  co = Promise.coroutine

  colors = require 'colors/safe'

  # lodash

  _ = require 'lodash'

  # init

  $$ or= $
