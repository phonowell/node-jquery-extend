# require

$ = require './../index'
_ = $._
Promise = require 'bluebird'
co = Promise.coroutine

# test variable

SUBJECT = [
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

# test lines

###

  delay([time])
  get(url, [data])
  i(msg)
  info([method], [type], msg)
  log()
  parseJson()
  parsePts(num)
  parseSafe()
  parseShortDate(option)
  parseString(data)
  parseTemp(string, data)
  serialize(string)
  shell(cmd)
  timeStamp([arg])

###

describe '$.delay([time])', ->

  it '$.delay(1e3)', co ->

    st = _.now()

    res = yield $.delay 1e3

    if res != $
      throw new Error 1

    ct = _.now()

    unless 900 < ct - st < 1100
      throw new Error 2

describe '$.get(url, [data])', ->

  it "$.get('https://app.anitama.net/web')", co ->

    data = yield $.get 'https://app.anitama.net/web'

    if $.type(data) != 'object'
      throw new Error 1

    if data.success != true
      throw new Error 2

describe '$.i(msg)', ->

  it "$.i('test message')", ->

    string = 'test message'

    res = $.i string

    if res != string
      throw new Error()

describe '$.info([method], [type], msg)', ->

  it "$.info('test message')", ->

    string = 'test message'

    res = $.info string

    if res != string
      throw new Error()

describe '$.log()', ->

  it '$.log()', ->

    if $.log != console.log
      throw new Error()

describe '$.parseJson()', ->

  it '$.parseJson()', ->

    if $.parseJson != $.parseJSON
      throw new Error()

describe '$.parsePts(num)', ->

  LIST = [
    [0, '0']
    [100, '100']
    [1e3, '1,000']
    [1e4, '10,000']
    [1e5, '10万']
    [1234567, '123.4万']
  ]

  _.each LIST, (a) ->

    it "$.parsePts(#{a[0]})", ->

      if $.parsePts(a[0]) != a[1]
        throw new Error()

describe '$.parseSafe()', ->

  it '$.parseSafe()', ->

    if $.parseSafe != _.escape
      throw new Error()

describe '$.parseShortDate(option)', ->

  LIST = [
    ['2012.12.21', '20121221']
    ['1999.1.1', '19990101']
    ['2050.2.28', '20500228']
  ]

  _.each LIST, (a) ->

    it "$.parseShortDate('#{a[0]}')", ->

      if $.parseShortDate($.timeStamp a[0]) != a[1]
        throw new Error()

describe '$.parseString(data)', ->

  LIST = [
    '1024'
    'hello world'
    'true'
    '[1,2,3]'
    '{"a":1,"b":2}'
    SUBJECT[5].toString()
    SUBJECT[6].toString()
    SUBJECT[7].toString()
    SUBJECT[8].toString()
    'null'
    'undefined'
    'NaN'
  ]

  _.each LIST, (a, i) ->

    p = SUBJECT[i]
    type = $.type p
    if type == 'number' and _.isNaN p then type = 'NaN'

    it "$.parseString(#{p})", ->

      if $.parseString(p) != a
        throw new Error()

describe '$.parseTemp(string, data)', ->

  it "$.parseTemp('[a] is falling love with [b]!', {a: 'Homura', b: 'Madoka'})", ->

    temp = '[a] is falling love with [b]!'
    data =
      a: 'Homura'
      b: 'Madoka'
    res = $.parseTemp temp, data
    if res != 'Homura is falling love with Madoka!'
      throw new Error()

describe '$.serialize(string)', ->

  it "$.serialize('?a=1&b=2&c=3&d=4')", ->

    a = '?a=1&b=2&c=3&d=4'
    b =
      a: '1'
      b: '2'
      c: '3'
      d: '4'

    unless _.isEqual $.serialize(a), b
      throw new Error()

describe '$.shell(cmd)', ->

  it "$.shell('gulp noop')", co ->

    res = yield $.shell 'gulp noop'

    if !res
      throw new Error()

describe '$.timeStamp([arg])', ->

  it '$.timeStamp()', ->

    ts = _.floor $.now(), -3
    res = $.timeStamp()

    if res != ts
      throw new Error()

  it '$.timeStamp(1502777554000)', ->

    ts = 1502777554000
    res = $.timeStamp ts
    ts = _.floor ts, -3

    if res != ts
      throw new Error()

  LIST = [
    [2012, 12, 21]
    [1997, 7, 1]
    [1970, 1, 1]
  ]

  _.each LIST, (a) ->

    timeString = a.join '.'
    res = $.timeStamp timeString

    date = new Date()
    date.setFullYear a[0], a[1] - 1, a[2]
    date.setHours 0, 0, 0, 0
    ts = _.floor date.getTime(), -3

    it "$.timeStamp('#{timeString}')", ->

      if res != ts
        throw new Error()

  LIST = [
    [2012, 12, 21, 12, 21]
    [1997, 7, 1, 19, 30]
    [1970, 1, 1, 8, 1]
  ]

  _.each LIST, (a, i) ->

    timeString = "#{a[0...3].join '.'} #{a[3...].join ':'}"
    res = $.timeStamp timeString

    date = new Date()
    date.setFullYear a[0], a[1] - 1, a[2]
    date.setHours a[3], a[4], 0, 0
    ts = _.floor date.getTime(), -3

    it "$.timeStamp('#{timeString}')", ->

      if res != ts
        throw new Error()