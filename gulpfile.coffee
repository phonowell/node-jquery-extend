$$ = require 'fire-keeper'
{_, Promise} = $$.library
co = Promise.coroutine

# task

$$.task 'work', -> $$.shell 'start gulp watch'

$$.task 'watch', ->

  deb = _.debounce $$.task('build'), 1e3
  $$.watch [
    './source/index.coffee'
    './source/include/**/*.coffee'
  ], deb

  $test = './test/test.coffee'
  deb = _.debounce ->
    $$.compile $test,
      map: true
      minify: false
  , 1e3
  $$.watch $test, deb

$$.task 'build', co ->
  yield $$.remove [
    './index.js'
    './source/index.js'
  ]
  yield $$.compile './source/index.coffee', minify: false
  yield $$.copy './source/index.js'

$$.task 'lint', co -> yield $$.lint 'coffee'

$$.task 'prepare', co ->
  yield $$.remove './coffeelint.json'
  yield $$.compile './coffeelint.yml'

  yield $$.remove './test/test.js'
  yield $$.compile './test/test.coffee', minify: false

$$.task 'set', co ->

  if !(ver = $$.argv.version) then return

  yield $$.replace './package.json'
  , /"version": "[\d.]+"/, "\"version\": \"#{ver}\""

  yield $$.replace './source/include/init.coffee'
  , /version: '[\d.]+'/, "version: '#{ver}'"

$$.task 'init', co ->

  yield $$.remove './.gitignore'
  yield $$.copy './../kokoro/.gitignore'

  yield $$.remove './.npmignore'
  yield $$.copy './../kokoro/.npmignore'

  yield $$.remove './coffeelint.yml'
  yield $$.copy './../kokoro/coffeelint.yml'