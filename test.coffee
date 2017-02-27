$ = require './index'
_ = $._

# function

$total = [0, 0]

$test = (a, b, msg) ->
  $total[0]++
  if a == b then $.info 'success', $ok msg
  else
    $total[1]++
    $.info 'fail', $ok msg, false
    $.log "# #{a} is not #{b}"

$divide = (title) ->
  $.log $divide['__string__']
  if title
    $.log title
    $.log $divide['__string__']
$divide['__string__'] = _.trim _.repeat '- ', 16

$ok = (msg, ok) ->
  if !~msg.search /\[is]/ then return msg
  if ok == false then return msg.replace /\[is]/g, 'is not'
  msg.replace /\[is]/g, 'is'

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

# $.log()
do ->
  $divide '$.log()'
  $test $.log == console.log, true
  , "$.log() [is] console.log()"

# $.next()

# $.parseJson()
do ->
  $divide '$.parseJson()'
  for a, i in $SUBJECT
    $test _.isEqual($.parseJson($SUBJECT[i]), a), true
    , "$.parseJson(#{$.parseString $SUBJECT[i]}) [is] #{$.parseString a}"
  map =[
    ['[1,2,3]', [1, 2, 3]]
    ['{a:1,b:2}', {a: 1, b: 2}]
  ]
  for a in map
    $test _.isEqual($.parseJson(a[0]), a[1]), true
    , "$.parseJson(#{$.parseString a[0]}) [is] #{$.parseString a[1]}"

# $.parsePts()
do ->
  $divide '$.parsePts()'
  for a in [
    [0, '0']
    [100, '100']
    [1e3, '1,000']
    [1e4, '10,000']
    [1e5, '10万']
    [1234567, '123.4万']
  ]
    $test $.parsePts(a[0]), a[1]
    , "$.parsePts(#{$.parseString a[0]}) [is] #{a[1]}"

# $.parseSafe()

# $.parseShortDate()
do ->
  $divide '$.parseShortDate()'
  for a in [
    ['2012.12.21', '20121221']
    ['1999.1.1', '19990101']
    ['2050.2.28', '20500228']
  ]
    $test $.parseShortDate($.timeStamp a[0]), a[1]
    , "$.parseShortDate(#{a[0]}) [is] #{a[1]}"

# $.parseString()
do ->
  $divide '$.parseString()'
  for a, i in [
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
    $test $.parseString($SUBJECT[i]), a
    , "$.parseString(#{$.parseString $SUBJECT[i]}) [is] #{$.parseString a}"

# $.parseTemp()
do ->
  $divide '$.parseTemp()'
  temp = '[a] is falling love with [b]!'
  arg =
    a: 'Homura'
    b: 'Madoka'
  res = $.parseTemp temp, arg
  $test res, 'Homura is falling love with Madoka!'
  , "$.parseTemp(#{temp}, #{$.parseString arg}) [is] #{res}"

# $.shell()

# $.timeStamp()
do ->
  $divide '$.timeStamp()'

  res = $.timeStamp()
  ts = _.floor $.now(), -3
  $test res, ts, "$.timeStamp() [is] #{ts}"

  now = $.now()
  res = $.timeStamp now
  ts = _.floor now, -3
  $test res, ts, "$.timeStamp(#{now}) [is] #{ts}"

  list = [
    [2012, 12, 21]
    [1997, 7, 1]
    [1970, 1, 1]
  ]

  for a in list
    res = $.timeStamp p = a.join '.'
    date = new Date()
    date.setFullYear a[0], a[1] - 1, a[2]
    date.setHours 0, 0, 0, 0
    ts = _.floor date.getTime(), -3
    $test res, ts, "$.timeStamp('#{p}') [is] #{ts}"

  list = [
    [2012, 12, 21, 12, 21]
    [1997, 7, 1, 19, 30]
    [1970, 1, 1, 8, 1]
  ]

  for a in list
    res = $.timeStamp p = "#{a[0...3].join '.'} #{a[3...].join ':'}"
    date = new Date()
    date.setFullYear a[0], a[1] - 1, a[2]
    date.setHours a[3], a[4], 0, 0
    ts = _.floor date.getTime(), -3
    $test res, ts, "$.timeStamp('#{p}') [is] #{ts}"

# result
$.next 500, ->
  $divide 'Result'
  msg = "There has got #{$total[1]} fail(s) from #{$total[0]} test(s)."
  $.info 'result', msg

  $.next 500, -> process.exit()