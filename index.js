(function() {
  var $, _, axios, colors,
    slice = [].slice;

  $ = require('node-jquery-lite');

  colors = require('colors/safe');

  axios = require('axios');

  _ = $._;

  module.exports = $;


  /*
  
    $.parseJson()
    $.parsePts(num)
    $.parseSafe()
    $.parseShortDate(option)
    $.parseString(data)
    $.parseTemp(string, data)
   */

  $.parseJson = $.parseJSON;

  $.parsePts = function(num) {
    var n;
    if ((n = (num || 0) | 0) >= 1e5) {
      return (((n * 0.001) | 0) / 10) + '万';
    } else {
      return n.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
    }
  };

  $.parseSafe = _.escape;

  $.parseShortDate = function(option) {
    var a, arr, date, i, j, len;
    date = $.type(option) === 'date' ? option : new Date(option);
    arr = [date.getFullYear(), 1 + date.getMonth(), date.getDate()];
    for (i = j = 0, len = arr.length; j < len; i = ++j) {
      a = arr[i];
      arr[i] = $.parseString(a);
      if (i && arr[i].length < 2) {
        arr[i] = '0' + arr[i];
      }
    }
    return arr.join('');
  };

  $.parseString = function(data) {
    var d;
    switch ($.type(d = data)) {
      case 'string':
        return d;
      case 'array':
        return (JSON.stringify({
          _obj: d
        })).replace(/\{(.*)\}/, '$1').replace(/"_obj":/, '');
      case 'object':
        return JSON.stringify(d);
      default:
        return String(d);
    }
  };

  $.parseTemp = function(string, data) {
    var k, s, v;
    s = string;
    for (k in data) {
      v = data[k];
      s = s.replace(new RegExp('\\[' + k + '\\]', 'g'), v);
    }
    return s;
  };


  /*
  
    $.get()
    $.i(msg)
    $.info(arg)
    $.log()
    $.next(arg)
    $.post()
    $.serialize(string)
    $.shell(cmd, callback)
    $.timeStamp(arg)
   */

  $.get = axios.get;

  $.i = function(msg) {
    $.log(msg);
    return msg;
  };

  $.info = function() {
    var a, arg, arr, cache, date, message, method, msg, ref, short, type;
    arg = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    ref = (function() {
      switch (arg.length) {
        case 1:
          return ['log', 'default', arg[0]];
        case 2:
          return ['log', arg[0], arg[1]];
        default:
          return arg;
      }
    })(), method = ref[0], type = ref[1], msg = ref[2];
    if ($.info.isSilent) {
      return msg;
    }
    cache = $.info['__cache__'];
    short = _.floor(_.now(), -3);
    if (cache[0] !== short) {
      cache[0] = short;
      date = new Date();
      cache[1] = ((function() {
        var j, len, ref1, results;
        ref1 = [date.getHours(), date.getMinutes(), date.getSeconds()];
        results = [];
        for (j = 0, len = ref1.length; j < len; j++) {
          a = ref1[j];
          results.push(_.padStart(a, 2, 0));
        }
        return results;
      })()).join(':');
    }
    arr = ["[" + cache[1] + "]"];
    if (type !== 'default') {
      arr.push("<" + (type.toUpperCase()) + ">");
    }
    arr.push(msg);
    message = arr.join(' ');
    message = message.replace(/\[.*?]/g, function(text) {
      var cont;
      cont = text.replace(/\[|]/g, '');
      return "[" + (colors.gray(cont)) + "]";
    }).replace(/<.*?>/g, function(text) {
      var cont;
      cont = text.replace(/<|>/g, '');
      return "" + (colors.gray('<')) + (colors.cyan(cont)) + (colors.gray('>'));
    }).replace(/'.*?'/g, function(text) {
      var cont;
      cont = text.replace(/'/g, '');
      return colors.magenta(cont);
    });
    console[method](message);
    return msg;
  };

  $.info['__cache__'] = [];

  $.log = console.log;

  $.next = function() {
    var arg, callback, delay, ref;
    arg = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    ref = (function() {
      switch (arg.length) {
        case 1:
          return [0, arg[0]];
        default:
          return arg;
      }
    })(), delay = ref[0], callback = ref[1];
    if (!delay) {
      process.nextTick(callback);
      return;
    }
    return setTimeout(callback, delay);
  };

  $.post = axios.post;

  $.serialize = function(string) {
    var a, b, j, key, len, ref, ref1, res, value;
    switch ($.type(string)) {
      case 'object':
        return string;
      case 'string':
        if (!~string.search(/=/)) {
          return {};
        }
        res = {};
        ref = _.trim(string.replace(/\?/g, '')).split('&');
        for (j = 0, len = ref.length; j < len; j++) {
          a = ref[j];
          b = a.split('=');
          ref1 = [_.trim(b[0]), _.trim(b[1])], key = ref1[0], value = ref1[1];
          if (key.length) {
            res[key] = value;
          }
        }
        return res;
      default:
        return {};
    }
  };

  $.shell = function(cmd, callback) {
    var child, fn;
    fn = $.shell;
    fn.platform || (fn.platform = (require('os')).platform());
    fn.exec || (fn.exec = (require('child_process')).exec);
    fn.info || (fn.info = function(string) {
      var text;
      text = $.trim(string);
      if (!text.length) {
        return;
      }
      return $.log(text.replace(/\r/g, '\n').replace(/\n{2,}/g, ''));
    });
    if ($.type(cmd) === 'array') {
      cmd = fn.platform === 'win32' ? cmd.join('&') : cmd.join('&&');
    }
    $.info('shell', cmd);
    child = fn.exec(cmd);
    child.stdout.on('data', function(data) {
      return fn.info(data);
    });
    child.stderr.on('data', function(data) {
      return fn.info(data);
    });
    return child.on('close', function() {
      return typeof callback === "function" ? callback() : void 0;
    });
  };

  $.timeStamp = function(arg) {
    var a, arr, b, date, str, type;
    type = $.type(arg);
    if (type === 'number') {
      return _.floor(arg, -3);
    }
    if (type !== 'string') {
      return _.floor(_.now(), -3);
    }
    str = _.trim(arg).replace(/\s+/g, ' ').replace(/[-|\/]/g, '.');
    date = new Date();
    arr = str.split(' ');
    b = arr[0].split('.');
    date.setFullYear(b[0], b[1] - 1, b[2]);
    if (!(a = arr[1])) {
      date.setHours(0, 0, 0, 0);
    } else {
      a = a.split(':');
      date.setHours(a[0], a[1], a[2] || 0, 0);
    }
    return date.getTime();
  };

}).call(this);
