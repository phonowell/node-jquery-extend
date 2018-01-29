###

  delay([time])
  get(url, [data])
  next([delay], callback)
  post(url, [data])
  serialize(string)
  shell(cmd, callback)
  timeStamp([arg])

###

$.delay = (time = 0) ->

  await new Promise (resolve) ->
    setTimeout ->
      resolve()
    , time

  $.info 'delay', "delayed '#{time} ms'"

  # return
  $

$.get = (url, data) ->
  res = await axios.get url, params: data or {}
  res.data

$.post = (url, data) ->
  res = await axios.post url, qs.stringify data
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