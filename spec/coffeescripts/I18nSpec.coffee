
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
    @date = new Date(2008, 02, 01)
    @instance = new I18n()
    #taken directly from https://github.com/svenfuchs/i18n/blob/master/lib/i18n/tests/localization/date.rb
    @instance.locale = {
      date : {
        formats : {
          default : "%d.%m.%Y",
          short : "%d. %b",
          long : "%d. %B %Y",
        },
        day_names: ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"],
        abbr_day_names: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"], 
        month_names: ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember", null], 
        abbr_month_names:["Jan", "Feb", "Mar", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]
      }
    } 

  it "should localize Date: given the short format it uses it", ->
    # should be Mrz, shouldn't it?
    expect(@instance.l(@date, format: "short")).toEqual("01. Mar")

  it "should alias localize to l", ->
    expect(@instance.l).toEqual(@instance.localize)

  it "should localize Date: given the long format it uses it", ->
    expect(@instance.l(@date, format: "long")).toEqual('01. März 2008')

  it "should localize Date: given the default format it uses it", ->
    expect(@instance.l(@date, format: "default")).toEqual('01.03.2008')

  it "should localize Date: given a day name format it returns the correct day name", ->
    expect(@instance.l(@date, format: '%A')).toEqual('Samstag')

  it "should localize Date: given an abbreviated day name format it returns the correct abbreviated day name", ->
    expect(@instance.l(@date, format: '%a')).toEqual('Sa')

  it "should localize Date: given a month name format it returns the correct month name", ->
    expect(@instance.l(@date, format: '%B')).toEqual('März')

  it "should localize Date: given an abbreviated month name format it returns the correct abbreviated month name", ->
    # TODO should be Mrz, shouldn't it?
    expect(@instance.l(@date, format: '%b')).toEqual('Mar')

  it "should localize Date: given an unknown format it does not fail", ->
    expect(@instance.l(@date, format: '%x')).toEqual('%x') # really I don't know what we should return

  it "should localize Date: given null it raises an error", ->
    that = this
    expect(-> that.instance.l(null)).toThrow("Argument Error: null is not localizable")

  it "should localize Date: given undefined it raises an error", ->
    that = this
    expect(-> that.instance.l(undefined)).toThrow("Argument Error: undefined is not localizable")

  it "should localize Date: given a plain Object it raises an error", ->
    that = this
    expect(-> that.instance.l({})).toThrow("Argument Error: [object Object] is not localizable")

  it "should localize Date: given a format is missing it raises I18n::MissingTranslationData", ->
    that = this
    expect(-> that.instance.l(that.date, format: "missing")).toThrow("Argument Error: no such format")

  it "should localize Date: it does not alter the format string", ->
    expect(@instance.l(new Date(2009, 01, 01), format: "long")).toEqual('01. Februar 2009')
    expect(@instance.l(new Date(2009, 9, 1), format: "long")).toEqual('01. Oktober 2009')

  it "should localize a no date, but pass the % sign", ->
    expect(@instance.l(@date, format: '%%')).toEqual('%')
