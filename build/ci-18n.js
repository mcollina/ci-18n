(function() {
  var I18n;
  I18n = (function() {
    var innerLookup;
    function I18n(currentLocale, defaultLocale) {
      if (currentLocale == null) {
        currentLocale = {};
      }
      if (defaultLocale == null) {
        defaultLocale = void 0;
      }
      if (typeof currentLocale === 'string') {
        this.localeString = currentLocale;
      } else {
        this.localeVal = currentLocale;
      }
      if (typeof defaultLocale === 'string') {
        this.defaultString = defaultLocale;
      } else if (!(defaultLocale != null)) {
        this.defaultString = I18n.getDefaultLanguage();
      } else {
        this.defaultVal = defaultLocale || {};
      }
    }
    I18n.prototype.locale = function() {
      return this.localeVal || (this.localeVal = I18n.language(this.localeString));
    };
    I18n.prototype.defaultLocale = function() {
      return this.defaultVal || (this.defaultVal = I18n.language(this.defaultString));
    };
    innerLookup = function(locale, keywordList) {
      var keyword, _i, _len;
      for (_i = 0, _len = keywordList.length; _i < _len; _i++) {
        keyword = keywordList[_i];
        if (locale == null) {
          break;
        }
        locale = locale[keyword];
      }
      return locale;
    };
    I18n.prototype.translate = function(keywordList, options) {
      var lookup;
      if (options == null) {
        options = {};
      }
      keywordList = I18n.normalizeKeys(keywordList, options);
      lookup = innerLookup(this.locale(), keywordList) || options["default"] || innerLookup(this.defaultLocale(), keywordList);
      delete options.scope;
      delete options["default"];
      return I18n.interpolate(lookup, options);
    };
    I18n.prototype.localize = function(date, options) {
      var match, matches, regexp, replacement_builder, string, _i, _len;
      if (!(date instanceof Date)) {
        throw "Argument Error: " + date + " is not localizable";
      }
      regexp = /%([a-z]|%)/ig;
      string = options.format;
      matches = string.match(regexp);
      if (matches == null) {
        if (options.type == null) {
          throw "Argument Error: missing type";
        }
        if (options.type === "datetime") {
          options.type = "time";
        }
        string = this.translate("" + options.type + ".formats." + options.format);
        if (string != null) {
          matches = string.match(regexp);
        }
      }
      if (matches == null) {
        throw "Argument Error: no such format";
      }
      for (_i = 0, _len = matches.length; _i < _len; _i++) {
        match = matches[_i];
        match = match.slice(-1);
        replacement_builder = I18n.strftime[match];
        if (replacement_builder != null) {
          string = string.replace("%" + match, replacement_builder(date, this));
        }
      }
      return string;
    };
    I18n.prototype.t = I18n.prototype.translate;
    I18n.prototype.l = I18n.prototype.localize;
    return I18n;
  })();
  I18n.normalizeKeys = function(keywords, options) {
    var keyword, splitted_keywords, _i, _len, _ref;
    if (keywords == null) {
      keywords = [];
    }
    if (options == null) {
      options = {
        scope: []
      };
    }
    if (keywords instanceof Array) {
      return keywords;
    }
    splitted_keywords = [];
    _ref = keywords.split(".");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      keyword = _ref[_i];
      if ((keyword != null) && keyword !== '') {
        splitted_keywords.push(keyword);
      }
    }
    return I18n.normalizeKeys(options.scope).concat(splitted_keywords);
  };
  (function() {
    var interpolate_basic, interpolate_sprintf;
    interpolate_basic = function(string, option, value) {
      var new_string;
      new_string = string.replace(RegExp("%{" + option + "}", "g"), value);
      if (string === new_string) {
        return;
      }
      return new_string;
    };
    interpolate_sprintf = function(string, option, value) {
      var match, regexp, result;
      regexp = RegExp("%<" + option + ">(.*?\\d*\\.?\\d*[bBdiouxXeEfgGcps])");
      match = string.match(regexp);
      if (match == null) {
        return;
      }
      result = sprintf("%(keyword)" + match[1], {
        keyword: value
      });
      return string.replace(match[0], result);
    };
    return I18n.interpolate = function(string, options) {
      var new_string, option, value;
      if (options == null) {
        options = {};
      }
      if (!(string != null)) {
        return string;
      }
      for (option in options) {
        value = options[option];
        new_string = interpolate_basic(string, option, value);
        new_string || (new_string = interpolate_sprintf(string, option, value));
        if (new_string == null) {
          throw new Error("Missing placeholder for keyword \"" + option + "\"");
        }
        string = new_string;
      }
      return string;
    };
  })();
  I18n.strftime = {
    'd': function(date) {
      return ('0' + date.getDate()).slice(-2);
    },
    'b': function(date, i18n) {
      return i18n.t("date.abbr_month_names")[date.getMonth()];
    },
    'B': function(date, i18n) {
      return i18n.t("date.month_names")[date.getMonth()];
    },
    'a': function(date, i18n) {
      return i18n.t("date.abbr_day_names")[date.getDay()];
    },
    'A': function(date, i18n) {
      return i18n.t("date.day_names")[date.getDay()];
    },
    'Y': function(date) {
      return date.getFullYear();
    },
    'm': function(date) {
      return ('0' + (date.getMonth() + 1)).slice(-2);
    },
    'H': function(date) {
      return ('0' + (date.getHours())).slice(-2);
    },
    'M': function(date) {
      return ('0' + (date.getMinutes())).slice(-2);
    },
    'S': function(date) {
      return ('0' + (date.getSeconds())).slice(-2);
    },
    'z': function(date) {
      var tz_offset;
      tz_offset = date.getTimezoneOffset();
      return (tz_offset > 0 && '-' || '+') + ('0' + (tz_offset / 60)).slice(-2) + ('0' + (tz_offset % 60)).slice(-2);
    },
    'p': function(date, i18n) {
      return i18n.t("time")[date.getHours() >= 12 && 'pm' || 'am'];
    },
    'e': function(date) {
      return date.getDate();
    },
    'I': function(date) {
      return ('0' + (date.getHours() % 12)).slice(-2);
    },
    'j': function(date) {
      return (((date.getTime() - new Date("Jan 1 " + date.getFullYear()).getTime()) / (1000 * 60 * 60 * 24) + 1) + '').split(/\./)[0];
    },
    'k': function(date) {
      return date.getHours();
    },
    'l': function(date) {
      return date.getHours() % 12;
    },
    'w': function(date) {
      return date.getDay();
    },
    'y': function(date) {
      return ("" + (date.getYear())).slice(-2);
    },
    '%': function() {
      return '%';
    }
  };
  (function() {
    var defaultLanguage, languages;
    languages = {};
    defaultLanguage = void 0;
    I18n.addLanguage = function(name, lang) {
      return languages[name] = lang;
    };
    I18n.clearLanguages = function() {
      return languages = {};
    };
    I18n.language = function(name) {
      return languages[name];
    };
    I18n.setDefaultLanguage = function(name) {
      return defaultLanguage = name;
    };
    return I18n.getDefaultLanguage = function() {
      return defaultLanguage;
    };
  })();
  I18n.load = function(path, lang) {
    var script, url;
    url = "" + path + "/" + lang + ".js";
    script = document.createElement('script');
    script.setAttribute('src', url);
    return document.getElementsByTagName('head')[0].appendChild(script);
  };
  I18n.detectLanguage = function(navigator) {
    var name, _i, _len, _ref;
    _ref = ["language", "browserLanguage"];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      name = _ref[_i];
      if (navigator[name] != null) {
        return navigator[name];
      }
    }
  };
  I18n.autoloadAndSetup = function(options) {
    var lang, langsToLoad, _i, _len;
    if (options.language == null) {
      options.language = I18n.detectLanguage(window.navigator);
    }
    langsToLoad = [options.language];
    if (options["default"] != null) {
      langsToLoad.push(options["default"]);
    }
    for (_i = 0, _len = langsToLoad.length; _i < _len; _i++) {
      lang = langsToLoad[_i];
      I18n.load(options.path, lang);
    }
    return I18n.setup(options.language, options["default"]);
  };
  I18n.setup = function(locale, defaultLocale) {
    return window.$i18n = new I18n(locale, defaultLocale);
  };
  I18n.autosetup = function(defaultLocale) {
    var locale;
    locale = I18n.detectLanguage(window.navigator);
    return I18n.setup(locale, defaultLocale);
  };
  window.I18n = I18n;
}).call(this);

/**
sprintf() for JavaScript 0.7-beta1
http://www.diveintojavascript.com/projects/javascript-sprintf

Copyright (c) Alexandru Marasteanu <alexaholic [at) gmail (dot] com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of sprintf() for JavaScript nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Alexandru Marasteanu BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Changelog:
2010.09.06 - 0.7-beta1
  - features: vsprintf, support for named placeholders
  - enhancements: format cache, reduced global namespace pollution

2010.05.22 - 0.6:
 - reverted to 0.4 and fixed the bug regarding the sign of the number 0
 Note:
 Thanks to Raphael Pigulla <raph (at] n3rd [dot) org> (http://www.n3rd.org/)
 who warned me about a bug in 0.5, I discovered that the last update was
 a regress. I appologize for that.

2010.05.09 - 0.5:
 - bug fix: 0 is now preceeded with a + sign
 - bug fix: the sign was not at the right position on padded results (Kamal Abdali)
 - switched from GPL to BSD license

2007.10.21 - 0.4:
 - unit test and patch (David Baird)

2007.09.17 - 0.3:
 - bug fix: no longer throws exception on empty paramenters (Hans Pufal)

2007.09.11 - 0.2:
 - feature: added argument swapping

2007.04.03 - 0.1:
 - initial release
**/

var sprintf = (function() {
	function get_type(variable) {
		return Object.prototype.toString.call(variable).slice(8, -1).toLowerCase();
	}
	function str_repeat(input, multiplier) {
		for (var output = []; multiplier > 0; output[--multiplier] = input) {/* do nothing */}
		return output.join('');
	}

	var str_format = function() {
		if (!str_format.cache.hasOwnProperty(arguments[0])) {
			str_format.cache[arguments[0]] = str_format.parse(arguments[0]);
		}
		return str_format.format.call(null, str_format.cache[arguments[0]], arguments);
	};

	str_format.format = function(parse_tree, argv) {
		var cursor = 1, tree_length = parse_tree.length, node_type = '', arg, output = [], i, k, match, pad, pad_character, pad_length;
		for (i = 0; i < tree_length; i++) {
			node_type = get_type(parse_tree[i]);
			if (node_type === 'string') {
				output.push(parse_tree[i]);
			}
			else if (node_type === 'array') {
				match = parse_tree[i]; // convenience purposes only
				if (match[2]) { // keyword argument
					arg = argv[cursor];
					for (k = 0; k < match[2].length; k++) {
						if (!arg.hasOwnProperty(match[2][k])) {
							throw(sprintf('[sprintf] property "%s" does not exist', match[2][k]));
						}
						arg = arg[match[2][k]];
					}
				}
				else if (match[1]) { // positional argument (explicit)
					arg = argv[match[1]];
				}
				else { // positional argument (implicit)
					arg = argv[cursor++];
				}

				if (/[^s]/.test(match[8]) && (get_type(arg) != 'number')) {
					throw(sprintf('[sprintf] expecting number but found %s', get_type(arg)));
				}
				switch (match[8]) {
					case 'b': arg = arg.toString(2); break;
					case 'c': arg = String.fromCharCode(arg); break;
					case 'd': arg = parseInt(arg, 10); break;
					case 'e': arg = match[7] ? arg.toExponential(match[7]) : arg.toExponential(); break;
					case 'f': arg = match[7] ? parseFloat(arg).toFixed(match[7]) : parseFloat(arg); break;
					case 'o': arg = arg.toString(8); break;
					case 's': arg = ((arg = String(arg)) && match[7] ? arg.substring(0, match[7]) : arg); break;
					case 'u': arg = Math.abs(arg); break;
					case 'x': arg = arg.toString(16); break;
					case 'X': arg = arg.toString(16).toUpperCase(); break;
				}
				arg = (/[def]/.test(match[8]) && match[3] && arg >= 0 ? '+'+ arg : arg);
				pad_character = match[4] ? match[4] == '0' ? '0' : match[4].charAt(1) : ' ';
				pad_length = match[6] - String(arg).length;
				pad = match[6] ? str_repeat(pad_character, pad_length) : '';
				output.push(match[5] ? arg + pad : pad + arg);
			}
		}
		return output.join('');
	};

	str_format.cache = {};

	str_format.parse = function(fmt) {
		var _fmt = fmt, match = [], parse_tree = [], arg_names = 0;
		while (_fmt) {
			if ((match = /^[^\x25]+/.exec(_fmt)) !== null) {
				parse_tree.push(match[0]);
			}
			else if ((match = /^\x25{2}/.exec(_fmt)) !== null) {
				parse_tree.push('%');
			}
			else if ((match = /^\x25(?:([1-9]\d*)\$|\(([^\)]+)\))?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosuxX])/.exec(_fmt)) !== null) {
				if (match[2]) {
					arg_names |= 1;
					var field_list = [], replacement_field = match[2], field_match = [];
					if ((field_match = /^([a-z_][a-z_\d]*)/i.exec(replacement_field)) !== null) {
						field_list.push(field_match[1]);
						while ((replacement_field = replacement_field.substring(field_match[0].length)) !== '') {
							if ((field_match = /^\.([a-z_][a-z_\d]*)/i.exec(replacement_field)) !== null) {
								field_list.push(field_match[1]);
							}
							else if ((field_match = /^\[(\d+)\]/.exec(replacement_field)) !== null) {
								field_list.push(field_match[1]);
							}
							else {
								throw('[sprintf] huh?');
							}
						}
					}
					else {
						throw('[sprintf] huh?');
					}
					match[2] = field_list;
				}
				else {
					arg_names |= 2;
				}
				if (arg_names === 3) {
					throw('[sprintf] mixing positional and named placeholders is not (yet) supported');
				}
				parse_tree.push(match);
			}
			else {
				throw('[sprintf] huh?');
			}
			_fmt = _fmt.substring(match[0].length);
		}
		return parse_tree;
	};

	return str_format;
})();

var vsprintf = function(fmt, argv) {
	argv.unshift(fmt);
	return sprintf.apply(null, argv);
};
