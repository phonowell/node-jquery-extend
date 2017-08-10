$$ = require 'fire-keeper'
{_, Promise} = $$.library
co = Promise.coroutine

$ = require './index'

# task

###

  build
  lint
  prepare
  set
  test
  watch
  work

###

$$.task 'build', co ->

  yield $$.remove [
    './index.js'
    './source/index.js'
  ]

  yield $$.compile './source/index.coffee',
    minify: false
  yield $$.copy './source/index.js', './'

$$.task 'lint', co ->

  yield $$.task('kokoro')()

  yield $$.lint [
    './gulpfile.coffee'
    './source/**/*.coffee'
  ]

$$.task 'prepare', co ->

  yield $$.remove './test/test.js'
  yield $$.compile './test/test.coffee',
    minify: false

$$.task 'set', co ->

  if !(ver = $$.argv.version) then return

  yield $$.replace './package.json'
  , /"version": "[\d.]+"/, "\"version\": \"#{ver}\""

$$.task 'test', co ->
  yield $$.compile './test/**/*.coffee'
  $$.shell 'start npm test'

$$.task 'watch', ->

  # build

  deb = _.debounce $$.task('build'), 1e3
  $$.watch [
    './source/index.coffee'
    './source/include/**/*.coffee'
  ], deb

  # test

  $test = './test/test.coffee'
  deb = _.debounce ->
    $$.compile $test,
      map: true
      minify: false
  , 1e3
  $$.watch $test, deb

$$.task 'work', -> $$.shell 'start gulp watch'

#$$.task 'z', ->