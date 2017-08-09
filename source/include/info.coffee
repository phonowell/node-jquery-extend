###

  $.i(msg)
  $.info([method], [type], msg)
  $.log()

###

$.i = (msg) ->
  $.log msg
  msg

do ->

  fn = (arg...) ->

    [method, type, msg] = switch arg.length
      when 1 then ['log', 'default', arg[0]]
      when 2 then ['log', arg[0], arg[1]]
      when 3 then arg
      else throw new Error 'invalid argument length'

    if fn.isSilent then return msg

    list = ["[#{fn.getTimeString()}]"]
    if type != 'default' then list.push "<#{type.toUpperCase()}>"
    list.push fn.renderPath msg

    console[method] fn.renderColor list.join ' '

    # return
    msg

  ###

    __cache__
    __reg_base__
    __reg_home__

    getTimeString()
    renderColor(msg)
    renderPath(msg)

  ###

  fn['__cache__'] = []

  fn['__reg_base__'] = new RegExp process.cwd()

  fn['__reg_home__'] = new RegExp (require 'os').homedir()

  fn.getTimeString = ->

    cache = fn['__cache__']
    ts = _.floor _.now(), -3

    if ts == cache[0] then return cache[1]

    date = new Date()
    list = [
      date.getHours()
      date.getMinutes()
      date.getSeconds()
    ]

    cache[0] = ts
    cache[1] = (_.padStart a, 2, 0 for a in list).join ':'

  fn.renderColor = (msg) ->

    msg
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

  fn.renderPath = (msg) ->

    if msg[0] in ['.', '~'] then return msg

    msg
    .replace fn['__reg_base__'], '.'
    .replace fn['__reg_home__'], '~'

  # return
  $.info = fn

$.log = console.log