
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
