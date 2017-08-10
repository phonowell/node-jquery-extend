(function() {
  var $, Promise, _, axios, co, colors, qs,
    slice = [].slice;

  $ = require('node-jquery-lite');

  axios = require('axios');

  qs = require('qs');

  Promise = require('bluebird');

  co = Promise.coroutine;

  colors = require('colors/safe');

  _ = $._;

  module.exports = $;


  /*
  
    $.i(msg)
    $.info([method], [type], msg)
    $.log()
   */

  $.i = function(msg) {
    $.log(msg);
    return msg;
  };

  (function() {
    var fn;
    fn = function() {
      var arg, list, method, msg, ref, type;
      arg = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      ref = (function() {
        switch (arg.length) {
          case 1:
            return ['log', 'default', arg[0]];
          case 2:
            return ['log', arg[0], arg[1]];
          case 3:
            return arg;
          default:
            throw new Error('invalid argument length');
        }
      })(), method = ref[0], type = ref[1], msg = ref[2];
      if (fn.isSilent) {
        return msg;
      }
      list = ["[" + (fn.getTimeString()) + "]"];
      if (type !== 'default') {
        list.push("<" + (type.toUpperCase()) + ">");
      }
      list.push(fn.renderPath(msg));
      console[method](fn.renderColor(list.join(' ')));
      return msg;
    };

    /*
    
      __cache__
      __reg_base__
      __reg_home__
    
      getTimeString()
      renderColor(msg)
      renderPath(msg)
     */
    fn['__cache__'] = [];
    fn['__reg_base__'] = new RegExp(process.cwd(), 'g');
    fn['__reg_home__'] = new RegExp((require('os')).homedir(), 'g');
    fn.getTimeString = function() {
      var a, cache, date, list, ts;
      cache = fn['__cache__'];
      ts = _.floor(_.now(), -3);
      if (ts === cache[0]) {
        return cache[1];
      }
      date = new Date();
      list = [date.getHours(), date.getMinutes(), date.getSeconds()];
      cache[0] = ts;
      return cache[1] = ((function() {
        var j, len, results;
        results = [];
        for (j = 0, len = list.length; j < len; j++) {
          a = list[j];
          results.push(_.padStart(a, 2, 0));
        }
        return results;
      })()).join(':');
    };
    fn.renderColor = function(msg) {
      return msg.replace(/\[.*?]/g, function(text) {
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
    };
    fn.renderPath = function(msg) {
      return msg.replace(fn['__reg_base__'], '.').replace(fn['__reg_home__'], '~');
    };
    return $.info = fn;
  })();

  $.log = console.log;


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

  (function() {
    var fn;
    fn = function(cmd, callback) {
      return new Promise(function(resolve) {
        var child;
        cmd = (function() {
          switch ($.type(cmd)) {
            case 'array':
              return cmd.join(" " + fn.separator + " ");
            case 'string':
              return cmd;
            default:
              throw new Error('invalid argument type');
          }
        })();
        $.info('shell', cmd);
        child = fn.exec(cmd);
        child.stdout.on('data', function(data) {
          return fn.info(data);
        });
        child.stderr.on('data', function(data) {
          return fn.info(data);
        });
        return child.on('close', function() {
          resolve();
          return typeof callback === "function" ? callback() : void 0;
        });
      });
    };

    /*
    
      exec
      separator
    
      info(string)
     */
    fn.exec = (require('child_process')).exec;
    fn.separator = (function() {
      var platform;
      platform = (require('os')).platform();
      switch (platform) {
        case 'win32':
          return '&';
        default:
          return '&&';
      }
    })();
    fn.info = function(string) {
      string = $.trim(string);
      if (!string.length) {
        return;
      }
      string = string.replace(/\r/g, '\n').replace(/\n{2,}/g, '');
      return $.log(string);
    };
    return $.shell = fn;
  })();


  /*
  
    $.get(url, [data])
    $.next([delay], callback)
    $.post(url, [data])
    $.serialize(string)
    $.shell(cmd, callback)
    $.timeStamp([arg])
   */

  $.get = co(function*(url, data) {
    var res;
    res = (yield axios.get(url, {
      params: data || {}
    }));
    return res.data;
  });

  $.next = function() {
    var arg, callback, delay, ref;
    arg = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    ref = (function() {
      switch (arg.length) {
        case 1:
          return [0, arg[0]];
        case 2:
          return arg;
        default:
          throw new Error('invalid argument length');
      }
    })(), delay = ref[0], callback = ref[1];
    if (!delay) {
      return process.nextTick(callback);
    }
    return setTimeout(callback, delay);
  };

  $.post = co(function*(url, data) {
    var res;
    res = (yield axios.post(url, qs.stringify(data)));
    return res.data;
  });

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
        throw new Error('invalid argument type');
    }
  };

  $.timeStamp = function(arg) {
    var a, b, date, list, string;
    switch ($.type(arg)) {
      case 'null':
      case 'undefined':
        return _.floor(_.now(), -3);
      case 'number':
        return _.floor(arg, -3);
      case 'string':
        break;
      default:
        throw new Error('invalid argument type');
    }
    string = _.trim(arg).replace(/\s+/g, ' ').replace(/[-|\/]/g, '.');
    date = new Date();
    list = string.split(' ');
    b = list[0].split('.');
    date.setFullYear(b[0], b[1] - 1, b[2]);
    if (!(a = list[1])) {
      date.setHours(0, 0, 0, 0);
    } else {
      a = a.split(':');
      date.setHours(a[0], a[1], a[2] || 0, 0);
    }
    return date.getTime();
  };

}).call(this);
