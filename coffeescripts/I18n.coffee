
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

  translate: (keywordList, options) ->
    keywordList = I18n.normalizeKeys(keywordList, options)
    lookup = innerLookup(@locale, keywordList) || innerLookup(@default, keywordList)
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

I18n.interpolate = (string, options = {}) ->
  return string if not string?
  for option, value of options
    string = string.replace(///%{#{option}}///g, value)
  string


