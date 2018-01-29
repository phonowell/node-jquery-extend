(function() {
  var $, _, axios, colors, qs;

  module.exports = $ = require('node-jquery-lite');

  // require
  axios = require('axios');

  qs = require('qs');

  colors = require('colors/safe');

  // lodash
  ({_} = $);

  /*

    i(msg)
    info([method], [type], msg)
    log()

  */
  $.i = function(msg) {
    $.log(msg);
    return msg;
  };

  (function() {
    var fn;
    fn = function(...arg) {
      var list, method, msg, type;
      [method, type, msg] = (function() {
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
      })();
      if (fn['__muted_token__']) {
        return msg;
      }
      list = [`[${fn.getTimeString()}]`];
      if (type !== 'default') {
        list.push(`<${type.toUpperCase()}>`);
      }
      list.push(fn.renderPath(msg));
      console[method](fn.renderColor(list.join(' ')));
      // return
      return msg;
    };
    /*

    __cache__
    __muted_token__
    __reg_base__
    __reg_home__

    getTimeString()
    pause(key)
    renderColor(msg)
    renderPath(msg)
    resume(key)

    */
    fn['__cache__'] = [];
    fn['__muted_token__'] = null;
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
    fn.pause = function(key) {
      var NS;
      NS = '__muted_token__';
      if (fn[NS]) {
        return;
      }
      return fn[NS] = key;
    };
    fn.renderColor = function(msg) {
      // [xxx]
      return ($.parseString(msg)).replace(/\[.*?]/g, function(text) {
        var cont;
        cont = text.replace(/\[|]/g, '');
        return `[${colors.gray(cont)}]`;
      // <xxx>
      }).replace(/<.*?>/g, function(text) {
        var cont;
        cont = text.replace(/<|>/g, '');
        return `${colors.gray('<')}${colors.cyan(cont)}${colors.gray('>')}`;
      // 'xxx'
      }).replace(/'.*?'/g, function(text) {
        var cont;
        cont = text.replace(/'/g, '');
        return colors.magenta(cont);
      });
    };
    fn.renderPath = function(msg) {
      return ($.parseString(msg)).replace(fn['__reg_base__'], '.').replace(fn['__reg_home__'], '~');
    };
    fn.resume = function(key) {
      var NS;
      NS = '__muted_token__';
      if (!fn[NS]) {
        return;
      }
      if (key !== fn[NS]) {
        return;
      }
      return fn[NS] = null;
    };
    // return
    return $.info = fn;
  })();

  $.log = console.log;

  /*

    parseJson()
    parsePts(num)
    parseSafe()
    parseShortDate(option)
    parseString(data)
    parseTemp(string, data)

  */
  $.parseJson = function(input) {
    switch ($.type(input)) {
      case 'array':
        return input;
      case 'buffer':
        return $.parseJSON(input);
      case 'object':
        return input;
      case 'string':
        return $.parseJSON(input);
      default:
        return null;
    }
  };

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
    switch ($.type(data)) {
      case 'array':
        return (JSON.stringify({
          __container__: data
        })).replace(/{(.*)}/, '$1').replace(/"__container__":/, '');
      case 'object':
        return JSON.stringify(data);
      case 'string':
        return data;
      default:
        return String(data);
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

  delay([time])
  get(url, [data])
  next([delay], callback)
  post(url, [data])
  serialize(string)
  shell(cmd, callback)
  timeStamp([arg])

  */
  $.delay = async function(time = 0) {
    await new Promise(function(resolve) {
      return setTimeout(function() {
        return resolve();
      }, time);
    });
    $.info('delay', `delayed '${time} ms'`);
    // return
    return $;
  };

  $.get = async function(url, data) {
    var res;
    res = (await axios.get(url, {
      params: data || {}
    }));
    return res.data;
  };

  $.post = async function(url, data) {
    var res;
    res = (await axios.post(url, qs.stringify(data)));
    return res.data;
  };

  $.serialize = function(string) {
    var a, b, j, key, len, ref, res, value;
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
          [key, value] = [_.trim(b[0]), _.trim(b[1])];
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
