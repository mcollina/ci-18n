
class I18n

  constructor: (@locale = {}, @default = {}) ->
    # nothing to do here

  # this is a private function
  innerLookup = (locale, keywordList) ->
    for keyword in keywordList.split(".")
      break unless locale?
      locale = locale[keyword] 
    locale

  translate: (keywordList) ->
    innerLookup(@locale, keywordList) || innerLookup(@default, keywordList)

  t: this::translate # coffeescript syntax to alias a method




