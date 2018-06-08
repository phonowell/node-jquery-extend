$ = require 'fire-keeper'

# task

###
build()
lint()
set()
test()
###

$.task 'build', ->

  await $.compile './source/index.coffee', './',
    minify: false

$.task 'lint', ->

  await $.task('kokoro')()

  await $.lint [
    './*.md'
  ]

  await $.lint [
    './gulpfile.coffee'
    './source/**/*.coffee'
  ]

$.task 'set', ->

  {ver} = $.argv
  if !ver
    throw new Error 'empty ver'

  pkg = './package.json'
  data = await $.read pkg
  data.version = ver
  await $.write pkg, data

$.task 'test', ->

  await $.compile './test/**/*.coffee'
  await $.shell 'npm test'
  await $.remove './test/**/*.js'

# $.task 'z', ->