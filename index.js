(function() {
  var $, _,
    slice = [].slice;

  $ = require('node-jquery-lite');

  _ = $._;

  module.exports = $;

  $.parseShortDate = function(param) {
    var a, arr, date, i, j, len;
    date = $.type(param) === 'date' ? param : new Date(param);
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

  $.parsePts = function(number) {
    var n;
    if ((n = (number || 0) | 0) >= 1e5) {
      return (((n * 0.001) | 0) / 10) + '万';
    } else {
      return n.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
    }
  };

  $.parseJson = $.parseJSON = function(data) {
    var err, ref, res;
    if ($.type(data) !== 'string') {
      return data;
    }
    try {
      res = eval("(" + data + ")");
      if ((ref = $.type(res)) === 'object' || ref === 'array') {
        return res;
      }
      return data;
    } catch (error) {
      err = error;
      return data;
    }
  };

  $.parseSafe = _.escape;

  $.parseTemp = function(string, object) {
    var k, s, v;
    s = string;
    for (k in object) {
      v = object[k];
      s = s.replace(new RegExp('\\[' + k + '\\]', 'g'), v);
    }
    return s;
  };

  $.next = function() {
    var args, callback, delay, ref;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    ref = (function() {
      switch (args.length) {
        case 1:
          return [0, args[0]];
        default:
          return args;
      }
    })(), delay = ref[0], callback = ref[1];
    if (!delay) {
      process.nextTick(callback);
      return;
    }
    return setTimeout(callback, delay);
  };

  $.log = console.log;

  $.info = function() {
    var a, args, arr, cache, date, method, msg, ref, short, type;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    ref = (function() {
      switch (args.length) {
        case 1:
          return ['log', 'default', args[0]];
        case 2:
          return ['log', args[0], args[1]];
        default:
          return args;
      }
    })(), method = ref[0], type = ref[1], msg = ref[2];
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
    console[method](arr.join(' '));
    return msg;
  };

  $.info['__cache__'] = [];

  $.i = function(msg) {
    $.log(msg);
    return msg;
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

}).call(this);
