###

  parseJson()
  parsePts(num)
  parseSafe()
  parseShortDate(option)
  parseString(data)
  parseTemp(string, data)

###

$.parseJson = $.parseJSON

$.parsePts = (num) ->
  if (n = (num or 0) | 0) >= 1e5 then (((n * 0.001) | 0) / 10) + '万'
  else n.toString().replace /(\d)(?=(\d{3})+(?!\d))/g, '$1,'

$.parseSafe = _.escape

$.parseShortDate = (option) ->
  date = if $.type(option) == 'date' then option else new Date option
  arr = [
    date.getFullYear()
    1 + date.getMonth()
    date.getDate()
  ]
  for a, i in arr
    arr[i] = $.parseString a
    if i and arr[i].length < 2
      arr[i] = '0' + arr[i]
  arr.join ''

$.parseString = (data) ->

  switch $.type data

    when 'array'

      (JSON.stringify __container__: data)
      .replace /{(.*)}/, '$1'
      .replace /"__container__":/, ''

    when 'object' then JSON.stringify data

    when 'string' then data

    else String data

$.parseTemp = (string, data) ->
  s = string
  for k, v of data
    s = s.replace (new RegExp '\\[' + k + '\\]', 'g'), v
  s
