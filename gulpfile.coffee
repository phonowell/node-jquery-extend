$$ = require 'fire-keeper'
{Promise} = $$.library
co = Promise.coroutine

# task

###

  build()
  lint()
  set()
  test()

###

$$.task 'build', co ->

  yield $$.compile './source/index.coffee', './',
    minify: false

$$.task 'lint', co ->

  yield $$.task('kokoro')()

  yield $$.lint [
    './*.md'
  ]

  yield $$.lint [
    './gulpfile.coffee'
    './source/**/*.coffee'
  ]

$$.task 'set', co ->

  {ver} = $$.argv
  if !ver
    throw new Error 'empty ver'

  yield $$.replace './package.json'
  , /"version": "[\d.]+"/, "\"version\": \"#{ver}\""

$$.task 'test', co ->

  yield $$.compile './test/**/*.coffee'
  yield $$.shell 'npm test'
  yield $$.remove './test/**/*.js'

#$$.task 'z', co ->