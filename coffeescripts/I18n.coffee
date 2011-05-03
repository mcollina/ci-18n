
class I18n

  # the first parameter is the main locale object
  # while the second is the fallback (default)
  constructor: (@locale = {}, @default = {}) ->
    # nothing to do here

  # this is a private function
  innerLookup = (locale, keywordList) ->
    for keyword in keywordList
      break unless locale?
      locale = locale[keyword] 
    locale

  translate: (keywordList, options = {}) ->
    keywordList = I18n.normalizeKeys(keywordList, options)
    lookup = innerLookup(@locale, keywordList) || options.default || innerLookup(@default, keywordList)

    # the scope is used by normalizeKeys, but it will be 
    # interpreted as a keyword placeholder by I18n.interpolate
    delete options.scope 

    # the default is used here, but it will be interpreted 
    # as a keyword placeholder by I18n.interpolate
    delete options.default 

    I18n.interpolate(lookup, options)

  localize: (date, options) ->
    throw "Argument Error: #{date} is not localizable" unless date instanceof Date
    regexp = /%([a-z]|%)/ig
    throw "Argument Error: missing type" unless options.type?
    options.type = "time" if options.type == "datetime"
    string = this.translate("#{options.type}.formats.#{options.format}") || options.format
    matches = string.match(regexp)
    throw "Argument Error: no such format" unless matches?

    for match in matches
      match = match.slice(-1)
      replacement_builder = I18n.strftime[match]
      string = string.replace("%#{match}", replacement_builder(date, this)) if replacement_builder?
    string

  t: this::translate # coffeescript syntax to alias a method
  l: this::localize # coffeescript syntax to alias a method

# extract an array of keys from the dot separated string
I18n.normalizeKeys = (keywords = [], options = { scope: [] }) ->
  return keywords if keywords instanceof Array

  splitted_keywords = []
  for keyword in keywords.split(".") 
    # it will be much better if we could just use filter
    splitted_keywords.push(keyword) if keyword? and keyword != ''
  I18n.normalizeKeys(options.scope).concat(splitted_keywords)

# interpolate function wrapper
( ->
  interpolate_basic = (string, option, value) ->
    new_string = string.replace(///%{#{option}}///g, value)
    return undefined if string == new_string
    new_string

  interpolate_sprintf = (string, option, value) ->
    # this regexp was taken from https://github.com/svenfuchs/i18n/blob/master/lib/i18n/interpolate/ruby.rb
    regexp = ///%<#{option}>(.*?\d*\.?\d*[bBdiouxXeEfgGcps])///  # matches placeholders like "%<foo>.d"
    match = string.match(regexp)
    return undefined unless match?

    result = sprintf("%(keyword)#{match[1]}", keyword: value)
    string.replace(match[0], result)

  I18n.interpolate = (string, options = {}) ->
    return string if not string?
    for option, value of options
      new_string = interpolate_basic(string, option, value)
      new_string ||= interpolate_sprintf(string, option, value)
      unless new_string?
        throw new Error("Missing placeholder for keyword \"#{option}\"") 
      string = new_string
    string
)()

I18n.strftime = {
  'd': (date) ->
    ('0' + date.getDate()).slice(-2)

  'b': (date, i18n) ->
    i18n.t("date.abbr_month_names")[date.getMonth()]

  'B': (date, i18n) ->
    i18n.t("date.month_names")[date.getMonth()]

  'a': (date, i18n) ->
    i18n.t("date.abbr_day_names")[date.getDay()]

  'A': (date, i18n) ->
    i18n.t("date.day_names")[date.getDay()]

  'Y': (date) ->
    date.getFullYear()

  'm': (date) ->
    ('0'+(date.getMonth() + 1)).slice(-2)

  'H': (date) ->
    ('0'+(date.getHours())).slice(-2)

  'M': (date) ->
    ('0'+(date.getMinutes())).slice(-2)

  'S': (date) ->
    ('0'+(date.getSeconds())).slice(-2)

  'z': (date) ->
    tz_offset = date.getTimezoneOffset()
    (tz_offset > 0 and '-' or '+') + ('0' + (tz_offset / 60)).slice(-2) + ('0' + (tz_offset % 60)).slice(-2)

  'p': (date, i18n) ->
    i18n.t("time")[date.getHours() >= 12 and 'pm' or 'am']

  'e': (date) ->
    date.getDate()

  'I': (date) ->
    ('0'+(date.getHours() % 12)).slice(-2)

  'j': (date) ->
    (((date.getTime() - new Date("Jan 1 " + date.getFullYear()).getTime()) / (1000 * 60 * 60 * 24) + 1) + '').split(/\./)[0]

  'k': (date) ->
    date.getHours()

  'l': (date) ->
    date.getHours() % 12

  'w': (date) ->
    date.getDay()

  'y': (date) ->
    "#{date.getYear()}".slice(-2)

  '%': -> '%'
}
