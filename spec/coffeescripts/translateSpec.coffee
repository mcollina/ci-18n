
describe "I18n#translate", ->

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
