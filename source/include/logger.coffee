class Logger

  ###
  __cache_separator__
  __cache_time__
  __cache_type__
  __reg_base__
  __reg_home__
  ###

  __cache_separator__: null
  __cache_time__: []
  __cache_type__: {}
  __reg_base__: new RegExp process.cwd(), 'g'
  __reg_home__: new RegExp (require 'os').homedir(), 'g'

  ###
  execute(arg...)
  getStringTime()
  pause(key)
  render(type, string)
  renderContent(string)
  renderPath(string)
  renderSeparator()
  renderTime()
  renderType(type)
  resume(key)
  ###

  execute: (arg...) ->

    [type, text] = switch arg.length
      when 1 then ['default', arg[0]]
      when 2 then arg
      else throw new Error 'invalid argument length'

    if @['__token_muted__'] then return text

    message = _.trim $.parseString text
    if !message.length then return text

    console.log @render type, message

    text # return

  getStringTime: ->

    date = new Date()
    listTime = [
      date.getHours()
      date.getMinutes()
      date.getSeconds()
    ]

    # return
    (_.padStart item, 2, 0 for item in listTime).join ':'

  pause: (key) ->

    stringToken = '__token_muted__'

    if @[stringToken] then return
    @[stringToken] = key

  render: (type, string) ->

    [
      @renderTime()
      @renderSeparator()
      @renderType type
      @renderContent string
    ].join ''

  renderContent: (string) ->

    message = @renderPath string

    # 'xxx'
    .replace /'.*?'/g, (text) ->
      cont = text.replace /'/g, ''
      if cont.length
        colors.magenta cont
      else "''"
    
    message # return

  renderPath: (string) ->
  
    string
    .replace @['__reg_base__'], '.'
    .replace @['__reg_home__'], '~'

  renderSeparator: ->
    
    cache = @['__cache_separator__']
    if cache then return cache

    stringSeparator = colors.gray '›'

    # return
    @['__cache_separator__'] = "#{stringSeparator} "

  renderTime: ->

    cache = @['__cache_time__']
    ts = _.floor _.now(), -3

    if ts == cache[0] then return cache[1]
    cache[0] = ts

    stringTime = colors.gray "[#{@getStringTime()}]"

    # return
    cache[1] = "#{stringTime} "

  renderType: (type) ->

    cache = @['__cache_type__']
    type = _.trim $.parseString type
    type = type.toLowerCase type

    if cache[type] then return cache[type]

    if type == 'default'
      return cache[type] = ''

    stringContent = colors.underline colors.cyan type
    stringPad = _.repeat ' ', 10 - type.length
    
    # return
    cache[type] = "#{stringContent}#{stringPad} "

  resume: (key) ->

    stringToken = '__token_muted__'

    if !@[stringToken] then return
    if key != @[stringToken] then return
    
    @[stringToken] = null

# return

###
$.i(msg)
$.info(arg...)
$.log()
###

$.i = (msg) ->
  $.log msg
  msg

# $.info()

logger = new Logger()

$.info = (arg...) -> logger.execute arg...
$.info.pause = (arg...) -> logger.pause arg...
$.info.renderPath = (arg...) -> logger.renderPath arg...
$.info.resume = (arg...) -> logger.resume arg...

$.log = console.log