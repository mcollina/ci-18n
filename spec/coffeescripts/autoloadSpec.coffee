
describe "I18n as autoload capable", ->

  beforeEach ->
    window.$i18n = undefined
    I18n.clearLanguages() if I18n.clearLanguages instanceof Function

  waitLanguageLoaded = (lang, func) ->
    waitsFor(1000, -> 
      I18n.language(lang)?
    , "the language wasn't loaded") 
    runs(func)

  it "should load some translations", ->
    I18n.load("/fixtures/", "it")
    waitLanguageLoaded("it", ->
      expect((new I18n("it")).t("hello")).toEqual("world")
    )

  it "should load some translations (disambiguation)", ->
    I18n.load("/fixtures/loc1", "it")
    waitLanguageLoaded("it", ->
      expect((new I18n("it")).t("hello")).toEqual("mondo")
    )

  it "should load some translations with default", ->
    I18n.load("/fixtures/loc1", "it")
    I18n.load("/fixtures/loc1", "en")
    waitLanguageLoaded("it", ->
      expect((new I18n("it", "en")).t("another")).toEqual("aaa")
    )

  it "should detect the language in Firefox", ->
    navigator = { language: "it" }
    expect(I18n.detectLanguage(navigator)).toEqual("it")

  it "should detect the language in Firefox (disambiguation)", ->
    navigator = { language: "en" }
    expect(I18n.detectLanguage(navigator)).toEqual("en")

  it "should detect the language in IE", ->
    navigator = { browserLanguage: "it" }
    expect(I18n.detectLanguage(navigator)).toEqual("it")

  it "should detect the language in IE (disambiguation)", ->
    navigator = { browserLanguage: "en" }
    expect(I18n.detectLanguage(navigator)).toEqual("en")

  it "should autoload a language", ->
    spyOn(I18n, "detectLanguage").andReturn("en")
    loadSpy = spyOn(I18n, "load")
    I18n.autoloadAndSetup(path: "/fixtures")
    expect(loadSpy.mostRecentCall.args).toEqual(["/fixtures", "en"])

  it "should autoload a language (disambiguation)", ->
    spyOn(I18n, "detectLanguage").andReturn("it")
    loadSpy = spyOn(I18n, "load")
    I18n.autoloadAndSetup(path: "/fixtures")
    expect(loadSpy.mostRecentCall.args).toEqual(["/fixtures", "it"])

  it "should autoload calling detectLanguage with window.navigator", ->
    detectSpy = spyOn(I18n, "detectLanguage").andReturn("en")
    I18n.autoloadAndSetup(path: "/fixtures")
    expect(detectSpy.mostRecentCall.args).toEqual([window.navigator])

  it "should autoload a language with a default", ->
    spyOn(I18n, "detectLanguage").andReturn("en")
    loadSpy = spyOn(I18n, "load")
    I18n.autoloadAndSetup(path: "/fixtures", default: "it")
    expect(loadSpy.argsForCall[0]).toEqual(["/fixtures", "en"])
    expect(loadSpy.argsForCall[1]).toEqual(["/fixtures", "it"])

  it "should autoload the lang files (disambiguation)", ->
    spyOn(I18n, "detectLanguage").andReturn("it")
    loadSpy = spyOn(I18n, "load")
    I18n.autoloadAndSetup(path: "/fixtures", default: "en")
    expect(loadSpy.argsForCall[0]).toEqual(["/fixtures", "it"])
    expect(loadSpy.argsForCall[1]).toEqual(["/fixtures", "en"])

  it "should autoload and setup an $i18n object based on the passed language", ->
    I18n.autoloadAndSetup(path: "/fixtures/loc1", language: "it", default: "en")
    waitLanguageLoaded("en", ->
      expect($i18n.t("another")).toEqual("aaa")
      expect($i18n.t("hello")).toEqual("mondo")
    )

  it "should autoload and call setup", ->
    setupSpy = spyOn(I18n, "setup")
    I18n.autoloadAndSetup(path: "/fixtures/loc1", language: "it", default: "en")
    expect(setupSpy.mostRecentCall.args).toEqual(["it", "en"])

  it "should setup a new instance", ->
    I18n.load("/fixtures/loc1", "it")
    I18n.load("/fixtures/loc1", "en")
    waitLanguageLoaded("it", ->
      I18n.setup("it", "en")
      expect($i18n.t("another")).toEqual("aaa")
      expect($i18n.t("hello")).toEqual("mondo")
    )
