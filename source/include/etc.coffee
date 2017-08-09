###

  $.get(url, [data])
  $.next([delay], callback)
  $.post(url, [data])
  $.serialize(string)
  $.shell(cmd, callback)
  $.timeStamp([arg])

###

$.get = co (url, data) ->
  res = yield axios.get url, params: data or {}
  res.data

$.next = (arg...) ->

  [delay, callback] = switch arg.length
    when 1 then [0, arg[0]]
    when 2 then arg
    else throw new Error 'invalid argument length'

  if !delay
    return process.nextTick callback

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
    else throw new Error 'invalid argument type'

$.timeStamp = (arg) ->

  switch $.type arg
    when 'null', 'undefined' then return _.floor _.now(), -3
    when 'number' then return _.floor arg, -3
    when 'string' then break
    else throw new Error 'invalid argument type'

  string = _.trim arg
  .replace /\s+/g, ' '
  .replace /[-|/]/g, '.'

  date = new Date()

  list = string.split ' '

  b = list[0].split '.'
  date.setFullYear b[0], (b[1] - 1), b[2]

  if !(a = list[1])
    date.setHours 0, 0, 0, 0
  else
    a = a.split ':'
    date.setHours a[0], a[1], a[2] or 0, 0

  date.getTime()