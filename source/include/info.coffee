###

  i(msg)
  info([method], [type], msg)
  log()

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

    if fn['__muted_token__'] then return msg

    list = ["[#{fn.getTimeString()}]"]
    if type != 'default' then list.push "<#{type.toUpperCase()}>"
    list.push fn.renderPath msg

    console[method] fn.renderColor list.join ' '

    # return
    msg

  ###

    __cache__
    __muted_token__
    __reg_base__
    __reg_home__

    getTimeString()
    pause(key)
    renderColor(msg)
    renderPath(msg)
    resume(key)

  ###

  fn['__cache__'] = []

  fn['__muted_token__'] = null

  fn['__reg_base__'] = new RegExp process.cwd(), 'g'

  fn['__reg_home__'] = new RegExp (require 'os').homedir(), 'g'

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

  fn.pause = (key) ->

    NS = '__muted_token__'

    if fn[NS] then return
    fn[NS] = key

  fn.renderColor = (msg) ->

    ($.parseString msg)
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

    ($.parseString msg)
    .replace fn['__reg_base__'], '.'
    .replace fn['__reg_home__'], '~'

  fn.resume = (key) ->

    NS = '__muted_token__'

    if !fn[NS] then return
    if key != fn[NS] then return
    fn[NS] = null

  # return
  $.info = fn

$.log = console.log