do ->

  fn = (cmd) ->

    new Promise (resolve) ->

      cmd = switch $.type cmd
        when 'array' then cmd.join " #{fn.separator} "
        when 'string' then cmd
        else throw new Error 'invalid argument type'

      $.info 'shell', cmd

      child = fn.exec cmd, (err) ->

        if err
          return resolve false

        resolve true

      child.stdout.on 'data', (data) -> fn.info data
      child.stderr.on 'data', (data) -> fn.info data

  ###

    exec
    separator

    info(string)

  ###

  fn.exec = (require 'child_process').exec

  fn.separator = do ->
    platform = (require 'os').platform()
    switch platform
      when 'win32' then '&'
      else '&&'

  fn.info = (string) ->

    string = $.trim string
    if !string.length then return

    string = string
    .replace /\r/g, '\n'
    .replace /\n{2,}/g, ''

    $.log string

  # return
  $.shell = fn
