
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
