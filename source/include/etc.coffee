###

  $.get()
  $.i(msg)
  $.info(arg)
  $.log()
  $.next(arg)
  $.post()
  $.serialize(string)
  $.shell(cmd, callback)
  $.timeStamp(arg)

###

$.get = co (url, data) ->
  res = yield axios.get url, params: data or {}
  res.data

$.i = (msg) ->
  $.log msg
  msg

$.info = (arg...) ->

  [method, type, msg] = switch arg.length
    when 1 then ['log', 'default', arg[0]]
    when 2 then ['log', arg[0], arg[1]]
    else arg

  if $.info.isSilent then return msg

  # time string
  cache = $.info['__cache__']
  short = _.floor _.now(), -3

  if cache[0] != short
    cache[0] = short
    date = new Date()
    cache[1] = (_.padStart a, 2, 0 for a in [date.getHours(), date.getMinutes(), date.getSeconds()]).join ':'

  arr = ["[#{cache[1]}]"]
  if type != 'default' then arr.push "<#{type.toUpperCase()}>"
  arr.push msg

  message = arr.join ' '
  message = message
  # [xxx]
  .replace /\[.*?]/g, (text) ->
    cont = text.replace /\[|]/g, ''
    "[#{colors.gray cont}]"
  # <xxx>
  .replace /<.*?>/g, (text) ->
    cont = text.replace /<|>/g, ''
    "#{colors.gray '<'}#{colors.cyan cont}#{colors.gray '>'}"
  # 'xxx'
  .replace /'.*?'/g, (text) ->
    cont = text.replace /'/g, ''
    colors.magenta cont

  console[method] message

  # return
  msg

$.info['__cache__'] = []

$.log = console.log

$.next = (arg...) ->

  [delay, callback] = switch arg.length
    when 1 then [0, arg[0]]
    else arg

  if !delay
    process.nextTick callback
    return

  setTimeout callback, delay

$.post = co (url, data) ->
  res = yield axios.post url, qs.stringify data
  res.data

$.serialize = (string) ->
  switch $.type string
    when 'object' then string
    when 'string'
      if !~string.search /=/ then return {}
      res = {}
      for a in _.trim(string.replace /\?/g, '').split '&'
        b = a.split '='
        [key, value] = [_.trim(b[0]), _.trim b[1]]
        if key.length then res[key] = value
      res
    else {}

$.timeStamp = (arg) ->

  type = $.type arg

  if type == 'number' then return _.floor arg, -3

  if type != 'string' then return _.floor _.now(), -3

  str = _.trim arg
  .replace /\s+/g, ' '
  .replace /[-|/]/g, '.'

  date = new Date()

  arr = str.split ' '

  b = arr[0].split '.'
  date.setFullYear b[0], (b[1] - 1), b[2]

  if !(a = arr[1])
    date.setHours 0, 0, 0, 0
  else
    a = a.split ':'
    date.setHours a[0], a[1], a[2] or 0, 0

  date.getTime()