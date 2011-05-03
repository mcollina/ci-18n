
describe "I18n#t", ->

  beforeEach ->
    @instance = new I18n()

  it "should be able to translate a simple keyword", ->
    @instance = new I18n(keyword: "hello world")
    expect(@instance.translate("keyword")).toEqual("hello world")

  it "should alias translate to t", ->
    expect(@instance.t).toEqual(@instance.translate)

  it "should be able to translate a simple keyword going to the default", ->
    @instance = new I18n({}, { keyword: "hello world" })
    expect(@instance.t("keyword")).toEqual("hello world")

  it "should be able to set the mail locale", ->
    @instance.locale = { keyword: "ahaha" }
    expect(@instance.t("keyword")).toEqual("ahaha")

  it "should be able to set the default locale", ->
    @instance.default = { keyword: "ahaha" }
    expect(@instance.t("keyword")).toEqual("ahaha")

  it "should be able to translate complex keyword", ->
    @instance.locale = { a: { keyword: "bbbb" } }
    expect(@instance.t("a.keyword")).toEqual("bbbb")

  it "should be able to translate complex keywords in the default", ->
    @instance.default = { a: { keyword: "bbbb" } }
    expect(@instance.t("a.keyword")).toEqual("bbbb")

  it "should be able to translate complex keywords in the default with some common ancestor in the locale", ->
    @instance.locale = { a: "grrr" }
    @instance.default = { a: { keyword: "bbbb" } }
    expect(@instance.t("a.keyword")).toEqual("bbbb")

  it "should be able to translate complex keywords in the default with a deep ancestor in the locale", ->
    @instance.locale = { a: "grrr" }
    @instance.default = { a: { long: { keyword: "bbbb" } } }
    expect(@instance.t("a.long.keyword")).toEqual("bbbb")

  it "should return undefined if it doesn't find a translation", ->
    expect(@instance.t("something")).toBeUndefined

  it "should call I18n.normalizeKeys", ->
    spyOn(I18n, "normalizeKeys").andCallThrough()
    @instance.t("something")
    expect(I18n.normalizeKeys).toHaveBeenCalled()

  it "should be able to translate complex keyword using a scope", ->
    @instance.locale = { a: { keyword: "bbbb" } }
    expect(@instance.t("keyword", scope: "a")).toEqual("bbbb")

  it "should call I18n.interpolate", ->
    spyOn(I18n, "interpolate").andCallThrough()
    @instance.t("something")
    expect(I18n.interpolate).toHaveBeenCalled()

  it "should interpolate with a scope", ->
    @instance.locale = { a: { keyword: "%{something}" } }
    expect(@instance.t("keyword", scope: "a", something: "bbbb")).toEqual("bbbb")

  it "should interpolate without a scope", ->
    @instance.locale = { a: "%{something}" } 
    expect(@instance.t("a", something: "bbbb")).toEqual("bbbb")

  it "should allow to specify a default for the current call", ->
    expect(@instance.t("a", default: "bbbb")).toEqual("bbbb")

  it "should work correctly even if a default was specified", ->
    @instance.locale = { a: "%{something}" } 
    expect(@instance.t("a", something: "bbbb", default: "aaaaa")).toEqual("bbbb")

describe "I18n.normalizeKeys", ->

  beforeEach ->
    @instance = I18n.normalizeKeys

  it "should return an array containing a single value if there are no dots", ->
    expect(@instance("hello")).toEqual(["hello"])

  it "should extract a simple dot-separated keyword list", ->
    expect(@instance("hello.world")).toEqual(["hello", "world"])

  it "should extract a simple dot-separated keyword list", ->
    expect(@instance("hello.world")).toEqual(["hello", "world"])

  it "should extract a simple dot-separated keyword list even with options with no scope", ->
    expect(@instance("hello.world", {})).toEqual(["hello", "world"])

  it "should return an array if an array was passed", ->
    expect(@instance(["hello", "world"])).toEqual(["hello", "world"])

  it "should remove empty keywords", ->
    expect(@instance("hello......world")).toEqual(["hello", "world"])

  it "should accept a scope", ->
    expect(@instance("hello.world", { scope: "foo.bar" })).toEqual(["foo", "bar", "hello", "world"])

describe "I18n.interpolate", ->

  beforeEach ->
    @instance = I18n.interpolate

  it "should work with undefined", ->
    expect(@instance(undefined)).toEqual(undefined)

  it "should work with null", ->
    expect(@instance(null)).toEqual(null)

  it "should work with the empty string", ->
    expect(@instance("")).toEqual("")

  it "should return the passed string if there is no placeholder", ->
    expect(@instance("hello world")).toEqual("hello world")

  it "should return the string with the placeholder replaced", ->
    expect(@instance("%{hello}", hello: "world")).toEqual("world")

  it "should return the string with two placeholders replaced", ->
    expect(@instance("%{a} %{b}", a: "hello", b: "world")).toEqual("hello world")

  it "should interpolate the same placeholder twice", ->
    expect(@instance("%{a} %{a}", a: "hello")).toEqual("hello hello")

  it "should raise an exception if a passed keyword didn't match", ->
    func = @instance
    expect( ->
      func("%{a}", a: "hello", b: "something")
    ).toThrow(new Error("Missing placeholder for keyword \"b\""))

  it "should interpolate named placeholders with sprintf syntax", ->
    expect(@instance("%<integer>d, %<float>.1f", integer: 10, float: 42.42)).toEqual("10, 42.4")

describe "I18n#localize", ->

  beforeEach ->
    @date = new Date(2008, 2, 1)
    @datetime = new Date(2008, 2, 1, 6) 
    @instance = new I18n()
    #taken directly from https://github.com/svenfuchs/i18n/blob/master/lib/i18n/tests/localization/date.rb
    @instance.locale = {
      date: {
        formats: {
          default: "%d.%m.%Y",
          short: "%d. %b",
          long: "%d. %B %Y",
        },
        day_names: ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"],
        abbr_day_names: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"], 
        month_names: ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember", null], 
        abbr_month_names:["Jan", "Feb", "Mar", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]
      }
      time: {
        formats: {
          default: "%a, %d. %b %Y %H:%M:%S %z",
          short: "%d. %b %H:%M",
          long: "%d. %B %Y %H:%M"
        },
        am: 'am',
        pm: 'pm'
      }
    } 

  it "should alias localize to l", ->
    expect(@instance.l).toEqual(@instance.localize)

  it "should raise an error if given null", ->
    expect(=> @instance.l(null)).toThrow("Argument Error: null is not localizable")

  it "should raise an error if given undefined", ->
    expect(=> @instance.l(undefined)).toThrow("Argument Error: undefined is not localizable")

  it "should raise an error if given a plain object", ->
    expect(=> @instance.l({})).toThrow("Argument Error: [object Object] is not localizable")

  it "should given no type it raises an error", ->
    expect(=> @instance.l(@date, format: '%a')).toThrow("Argument Error: missing type")

  it "should localize a no date, but pass the % sign", ->
    expect(@instance.l(@date, type: "date", format: '%%')).toEqual('%')

  it "should localize date: given the short format it uses it", ->
    # should be Mrz, shouldn't it?
    expect(@instance.l(@date, type: "date", format: "short")).toEqual("01. Mar")

  it "should localize date: given the long format it uses it", ->
    expect(@instance.l(@date, type: "date", format: "long")).toEqual('01. März 2008')

  it "should localize date: given the default format it uses it", ->
    expect(@instance.l(@date, type: "date", format: "default")).toEqual('01.03.2008')

  it "should localize date: given a day name format it returns the correct day name", ->
    expect(@instance.l(@date, type: "date", format: '%A')).toEqual('Samstag')

  it "should localize date: given an abbreviated day name format it returns the correct abbreviated day name", ->
    expect(@instance.l(@date, type: "date", format: '%a')).toEqual('Sa')

  it "should localize date: given a month name format it returns the correct month name", ->
    expect(@instance.l(@date, type: "date", format: '%B')).toEqual('März')

  it "should localize date: given an abbreviated month name format it returns the correct abbreviated month name", ->
    # TODO should be Mrz, shouldn't it?
    expect(@instance.l(@date, type: "date", format: '%b')).toEqual('Mar')

  it "should localize date: given an unknown format it does not fail", ->
    expect(@instance.l(@date, type: "date", format: '%x')).toEqual('%x') # really I don't know what we should return

  it "should localize date: given a format is missing it raises I18n::MissingTranslationData", ->
    expect(=> @instance.l(@date, type: "date", format: "missing")).toThrow("Argument Error: no such format")

  it "should localize date: it does not alter the format string", ->
    expect(@instance.l(new Date(2009,01, 01), type: "date", format: "long")).toEqual('01. Februar 2009')
    expect(@instance.l(new Date(2009, 9, 1), type: "date", format: "long")).toEqual('01. Oktober 2009')

  it "should localize datetime: given the short format it uses it", ->
    # TODO should be Mrz, shouldn't it?
    expect(@instance.l(@datetime, format: "short", type: "datetime")).toEqual('01. Mar 06:00')

  it "should localize datetime: given the long format it uses it", ->
    expect(@instance.l(@datetime, format: "long", type: "datetime")).toEqual('01. März 2008 06:00')

  it "should localize datetime: given the default format it uses it", ->
    spyOn(@datetime, "getTimezoneOffset").andReturn(0)
    expect(@instance.l(@datetime, format: "default", type: "datetime")).toEqual('Sa, 01. Mar 2008 06:00:00 +0000')

  it "should localize datetime: given a day name format it returns the correct day name", ->
    expect(@instance.l(@datetime, format: "%A", type: "datetime")).toEqual('Samstag')

  it "should localize datetime: given an abbreviated day name format it returns the correct abbreviated day name", ->
    expect(@instance.l(@datetime, format: "%a", type: "datetime")).toEqual('Sa')

  it "should localize datetime: given a month name format it returns the correct month name", ->
    expect(@instance.l(@datetime, format: "%B", type: "datetime")).toEqual('März')

  it "should localize datetime: given an abbreviated month name format it returns the correct abbreviated month name", ->
    expect(@instance.l(@datetime, format: "%b", type: "datetime")).toEqual('Mar')

  it "should localize datetime: given a an am date it returns the corrent meridian indicator", ->
    expect(@instance.l(@datetime, format: "%p", type: "datetime")).toEqual('am')

  it "should localize datetime: given a a pm date it returns the corrent meridian indicator", ->
    expect(@instance.l(new Date(2008, 1, 1, 20, 20), format: "%p", type: "datetime")).toEqual('pm')

  it "should localize datetime: given a day format it returns the correct day", ->
    expect(@instance.l(@datetime, format: "%e", type: "datetime")).toEqual('1')

  it "should localize datetime: given an hour padded format it returns the correct hour", ->
    expect(@instance.l(@datetime, format: "%I", type: "datetime")).toEqual('06')

  it "should localize datetime: given an hour padded format (pm) it returns the correct hour", ->
    expect(@instance.l(new Date(2008, 1, 1, 20, 20), format: "%I", type: "datetime")).toEqual('08')

  it "should localize datetime: given a day_of_year format (first day) it returns the correct day", ->
    expect(@instance.l(new Date(2008, 0, 1, 20, 20), format: "%j", type: "datetime")).toEqual('1')

  it "should localize datetime: given a day_of_year format (last day) it returns the correct day", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%j", type: "datetime")).toEqual('366')

  it "should localize datetime: given a 24 hour format it returns the correct hour not padded", ->
    expect(@instance.l(new Date(2008, 11, 31, 6, 20), format: "%k", type: "datetime")).toEqual('6')

  it "should localize datetime: given a 24 hour format it returns the correct hour not padded", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%k", type: "datetime")).toEqual('20')

  it "should localize datetime: given a 12 hour format it returns the correct hour not padded", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%l", type: "datetime")).toEqual('8')

  it "should localize datetime: given a 12 hour format it returns the correct hour not padded", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%l", type: "datetime")).toEqual('8')

  it "should localize datetime: given a week day format it returns the correct week day", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%w", type: "datetime")).toEqual('3')

  it "should localize datetime: given a abbr year format it returns the correct year", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%y", type: "datetime")).toEqual('08')
