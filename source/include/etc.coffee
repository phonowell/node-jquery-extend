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

$.get = axios.get

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

$.post = axios.post

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

$.shell = (cmd, callback) ->
  fn = $.shell
  fn.platform or= (require 'os').platform()
  fn.exec or= (require 'child_process').exec
  fn.info or= (string) ->
    text = $.trim string
    if !text.length then return
    $.log text.replace(/\r/g, '\n').replace /\n{2,}/g, ''

  if $.type(cmd) == 'array'
    cmd = if fn.platform == 'win32' then cmd.join('&') else cmd.join('&&')
  $.info 'shell', cmd

  # execute
  child = fn.exec cmd
  child.stdout.on 'data', (data) -> fn.info data
  child.stderr.on 'data', (data) -> fn.info data
  child.on 'close', -> callback?()

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