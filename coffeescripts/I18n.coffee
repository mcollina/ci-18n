
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

  t: this::translate # coffeescript syntax to alias a method

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


