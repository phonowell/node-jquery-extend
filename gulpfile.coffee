$ = require 'fire-keeper'

# task

###
build()
lint()
set()
test()
###

$.task 'build', ->

  await $.compile_ './source/index.coffee', './',
    minify: false

$.task 'lint', ->

  await $.task('kokoro')()

  await $.lint_ [
    './*.md'
  ]

  await $.lint_ [
    './gulpfile.coffee'
    './source/**/*.coffee'
  ]

$.task 'set', ->

  {ver} = $.argv
  if !ver
    throw new Error 'empty ver'

  pkg = './package.json'
  data = await $.read_ pkg
  data.version = ver
  await $.write_ pkg, data

$.task 'test', ->

  await $.compile_ './test/**/*.coffee'
  await $.shell_ 'npm test'
  await $.remove_ './test/**/*.js'

# $.task 'z', ->