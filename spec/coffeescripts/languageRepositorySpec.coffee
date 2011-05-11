
describe "I18n as a language repository", ->

  afterEach ->
    I18n.clearLanguages() if I18n.clearLanguages instanceof Function

  it "should add a language", ->
    I18n.addLanguage("it", { hello: "world" })
    expect(I18n.language("it")).toEqual(hello: "world")

  it "should add and clear languages", ->
    I18n.addLanguage("it", { hello: "world" })
    I18n.clearLanguages()
    expect(I18n.language("it")).toEqual(undefined)

  it "should create a I18n object based on the specified language", ->
    I18n.addLanguage("it", { hello: "world" })
    instance = new I18n("it")
    expect(instance.t("hello")).toEqual("world")

  it "should create a I18n object with a specified default language", ->
    I18n.addLanguage("it", { hello: "world" })
    instance = new I18n(undefined, "it")
    expect(instance.t("hello")).toEqual("world")
