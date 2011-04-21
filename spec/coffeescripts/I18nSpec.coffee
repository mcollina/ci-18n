
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

  it "should be able to translate complex keywords", ->
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

describe "I18n.normalizeKeys", ->

  beforeEach ->
    @instance = I18n.normalizeKeys

  it "should return an array containing a single value if there are no dots", ->
    expect(@instance("hello")).toEqual(["hello"])

  it "should extract a simple dot-separated keyword list", ->
    expect(@instance("hello.world")).toEqual(["hello", "world"])

  it "should extract a simple dot-separated keyword list", ->
    expect(@instance("hello.world")).toEqual(["hello", "world"])

  it "should return an array if an array was passed", ->
    expect(@instance(["hello", "world"])).toEqual(["hello", "world"])

  it "should remove empty keywords", ->
    expect(@instance("hello......world")).toEqual(["hello", "world"])

  it "should accept a scope", ->
    expect(@instance("hello.world", { scope: "foo.bar" })).toEqual(["foo", "bar", "hello", "world"])
