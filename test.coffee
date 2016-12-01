$ = require './index'
_ = $._

# function
$total = [0, 0]
$.test = (a, b, msg) ->
  $total[0]++
  if a == b
    $.info 'success', $.parseOK msg
  else
    $.info 'fail', $.parseOK msg, false
    $.log "# #{a} is not #{b}"
    $total[1]++

$.devide = (title) -> $.log "#{_.repeat '-', 16}#{if title then "> #{title}" else ''}"

$.parseOK = (msg, ok) ->
  if !~msg.search /\[is]/
    return msg
  if ok == false
    return msg.replace /\[is]/, 'is not'
  msg.replace /\[is]/, 'is'

$subject = [
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

# $.next()

# $.parseJson()
do ->
  $.devide '$.parseJson()'
  for a, i in $subject
    $.test _.isEqual($.parseJson($subject[i]), a), true
    , "$.parseJson(#{$.parseString $subject[i]}) [is] #{$.parseString a}"
  map =[
    ['[1,2,3]', [1, 2, 3]]
    ['{a:1,b:2}', {a: 1, b: 2}]
  ]
  for a in map
    $.test _.isEqual($.parseJson(a[0]), a[1]), true
    , "$.parseJson(#{$.parseString a[0]}) [is] #{$.parseString a[1]}"

# $.parsePts()
do ->
  $.devide '$.parsePts()'
  for a in [
    [0, '0']
    [100, '100']
    [1e3, '1,000']
    [1e4, '10,000']
    [1e5, '10万']
    [1234567, '123.4万']
  ]
    $.test $.parsePts(a[0]), a[1]
    , "$.parsePts(#{$.parseString a[0]}) [is] #{a[1]}"

# $.parseSafe()

# $.parseShortDate()
do ->
  $.devide '$.parseShortDate()'
  for a in [
    ['2012.12.21', '20121221']
    ['1999.1.1', '19990101']
    ['2050.2.28', '20500228']
  ]
    $.test $.parseShortDate($.timeStamp a[0]), a[1]
    , "$.parseShortDate(#{a[0]}) [is] #{a[1]}"

# $.parseString()
do ->
  $.devide '$.parseString()'
  for a, i in [
    '1024'
    'hello world'
    'true'
    '[1,2,3]'
    '{"a":1,"b":2}'
    $subject[5].toString()
    $subject[6].toString()
    $subject[7].toString()
    $subject[8].toString()
    'null'
    'undefined'
    'NaN'
  ]
    $.test $.parseString($subject[i]), a
    , "$.parseString(#{$.parseString $subject[i]}) [is] #{$.parseString a}"

# $.parseTemp()
do ->
  $.devide '$.parseTemp()'
  temp = '[a] is falling love with [b]!'
  arg =
    a: 'Homura'
    b: 'Madoka'
  res = $.parseTemp temp, arg
  $.test res, 'Homura is falling love with Madoka!'
  , "$.parseTemp(#{temp}, #{$.parseString arg}) [is] #{res}"

# $.shell()

# $.timeStamp()
do ->
  $.devide '$.timeStamp()'

  res = $.timeStamp()
  ts = _.floor $.now(), -3
  $.test res, ts, "$.timeStamp() [is] #{ts}"

  now = $.now()
  res = $.timeStamp now
  ts = _.floor now, -3
  $.test res, ts, "$.timeStamp(#{now}) [is] #{ts}"

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
    $.test res, ts, "$.timeStamp('#{p}') [is] #{ts}"

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
    $.test res, ts, "$.timeStamp('#{p}') [is] #{ts}"

# result
$.next 500, ->
  $.devide 'Result'
  msg = "There has got #{$total[1]} fail(s) from #{$total[0]} test(s)."
  $.info 'result', msg

  $.next 500, -> process.exit()