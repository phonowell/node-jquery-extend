$ = require './../index'
_ = $._

assert = require 'assert'
check = assert.equal
checkDeep = assert.deepEqual

# function

$SUBJECT = [
  1024 # number
  'hello world' # string
  true # boolean
  [1, 2, 3] # array
  {a: 1, b: 2} # object
  -> return null # function
  new Date() # date
  new Error('All Right') # error
  new Buffer('String') # buffer
  null # null
  undefined # undefined
  NaN # NaN
]

# $.i()

# $.info()

describe '$.log()', ->
  it '$.log()', ->
    check $.log, console.log

# $.next()

describe '$.parsePts()', ->
  LIST = [
    [0, '0']
    [100, '100']
    [1e3, '1,000']
    [1e4, '10,000']
    [1e5, '10万']
    [1234567, '123.4万']
  ]
  _.each LIST, (a) ->
    it a[0].toString(), -> check $.parsePts(a[0]), a[1]

# $.parseSafe()

describe '$.parseShortDate()', ->
  LIST = [
    ['2012.12.21', '20121221']
    ['1999.1.1', '19990101']
    ['2050.2.28', '20500228']
  ]
  _.each LIST, (a) ->
    it a[0], ->
      check $.parseShortDate($.timeStamp a[0]), a[1]

describe '$.parseString()', ->
  LIST = [
    '1024'
    'hello world'
    'true'
    '[1,2,3]'
    '{"a":1,"b":2}'
    $SUBJECT[5].toString()
    $SUBJECT[6].toString()
    $SUBJECT[7].toString()
    $SUBJECT[8].toString()
    'null'
    'undefined'
    'NaN'
  ]
  _.each LIST, (a, i) ->
    p = $SUBJECT[i]
    type = $.type p
    if type == 'number' and _.isNaN p then type = 'NaN'
    it type, -> check $.parseString(p), a

describe '$.parseTemp()', ->
  it '$.parseTemp()', ->
    temp = '[a] is falling love with [b]!'
    arg =
      a: 'Homura'
      b: 'Madoka'
    res = $.parseTemp temp, arg
    check res, 'Homura is falling love with Madoka!'

describe '$.serialize()', ->

  LIST = [
    {}
    {}
    {}
    {}
    {a: 1, b: 2}
    {}
    {}
    {}
    {}
    {}
    {}
    {}
  ]
  _.each LIST, (a, i) ->
    p = $SUBJECT[i]
    type = $.type p
    if type == 'number' and _.isNaN p then type = 'NaN'

    it type, -> checkDeep $.serialize(p), a

  it 'params', ->
    a = '?a=1&b=2&c=3&d=4'
    b =
      a: '1'
      b: '2'
      c: '3'
      d: '4'

    checkDeep $.serialize(a), b

# $.shell()

describe '$.timeStamp()', ->

  it 'null', ->
    res = $.timeStamp()
    ts = _.floor $.now(), -3
    check res, ts


  now = _.now()
  res = $.timeStamp now
  ts = _.floor now, -3
  it now.toString(), -> check res, ts

  LIST = [
    [2012, 12, 21]
    [1997, 7, 1]
    [1970, 1, 1]
  ]
  _.each LIST, (a, i) ->
    res = $.timeStamp p = a.join '.'
    date = new Date()
    date.setFullYear a[0], a[1] - 1, a[2]
    date.setHours 0, 0, 0, 0
    ts = _.floor date.getTime(), -3
    it p, -> check res, ts

  LIST = [
    [2012, 12, 21, 12, 21]
    [1997, 7, 1, 19, 30]
    [1970, 1, 1, 8, 1]
  ]
  _.each LIST, (a, i) ->
    res = $.timeStamp p = "#{a[0...3].join '.'} #{a[3...].join ':'}"
    date = new Date()
    date.setFullYear a[0], a[1] - 1, a[2]
    date.setHours a[3], a[4], 0, 0
    ts = _.floor date.getTime(), -3
    it p, -> check res, ts