
describe "I18n#localize", ->

  beforeEach ->
    @date = new Date(2008, 2, 1)
    @datetime = new Date(2008, 2, 1, 6) 
    #taken directly from https://github.com/svenfuchs/i18n/blob/master/lib/i18n/tests/localization/date.rb
    @instance = new I18n({
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
    })

  it "should alias localize to l", ->
    expect(@instance.l).toEqual(@instance.localize)

  it "should raise an error if given null", ->
    expect(=> @instance.l(null)).toThrow("Argument Error: null is not localizable")

  it "should raise an error if given undefined", ->
    expect(=> @instance.l(undefined)).toThrow("Argument Error: undefined is not localizable")

  it "should raise an error if given a plain object", ->
    expect(=> @instance.l({})).toThrow("Argument Error: [object Object] is not localizable")

  it "should localize date: given the short format it uses it", ->
    # should be Mrz, shouldn't it?
    expect(@instance.l(@date, type: "date", format: "short")).toEqual("01. Mar")

  it "should localize date: given the long format it uses it", ->
    expect(@instance.l(@date, type: "date", format: "long")).toEqual('01. März 2008')

  it "should localize date: given the default format it uses it", ->
    expect(@instance.l(@date, type: "date", format: "default")).toEqual('01.03.2008')

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

  it "should the % sign", ->
    expect(@instance.l(@date, format: '%%')).toEqual('%')

  it "should localize format: given a day name format it returns the correct day name", ->
    expect(@instance.l(@date, format: '%A')).toEqual('Samstag')

  it "should localize format: given an abbreviated day name format it returns the correct abbreviated day name", ->
    expect(@instance.l(@date, format: '%a')).toEqual('Sa')

  it "should localize format: given a month name format it returns the correct month name", ->
    expect(@instance.l(@date, format: '%B')).toEqual('März')

  it "should localize format: given an abbreviated month name format it returns the correct abbreviated month name", ->
    # TODO should be Mrz, shouldn't it?
    expect(@instance.l(@date, format: '%b')).toEqual('Mar')

  it "should localize format: given an unknown format it does not fail", ->
    expect(@instance.l(@date, format: '%x')).toEqual('%x') # really I don't know what we should return

  it "should localize format: given a day name format it returns the correct day name", ->
    expect(@instance.l(@datetime, format: "%A")).toEqual('Samstag')

  it "should localize format: given an abbreviated day name format it returns the correct abbreviated day name", ->
    expect(@instance.l(@datetime, format: "%a")).toEqual('Sa')

  it "should localize format: given a month name format it returns the correct month name", ->
    expect(@instance.l(@datetime, format: "%B")).toEqual('März')

  it "should localize format: given an abbreviated month name format it returns the correct abbreviated month name", ->
    expect(@instance.l(@datetime, format: "%b")).toEqual('Mar')

  it "should localize format: given a an am date it returns the corrent meridian indicator", ->
    expect(@instance.l(@datetime, format: "%p")).toEqual('am')

  it "should localize format: given a a pm date it returns the corrent meridian indicator", ->
    expect(@instance.l(new Date(2008, 1, 1, 20, 20), format: "%p")).toEqual('pm')

  it "should localize format: given a day format it returns the correct day", ->
    expect(@instance.l(@datetime, format: "%e")).toEqual('1')

  it "should localize format: given an hour padded format it returns the correct hour", ->
    expect(@instance.l(@datetime, format: "%I")).toEqual('06')

  it "should localize format: given an hour padded format (pm) it returns the correct hour", ->
    expect(@instance.l(new Date(2008, 1, 1, 20, 20), format: "%I")).toEqual('08')

  it "should localize format: given a day_of_year format (first day) it returns the correct day", ->
    expect(@instance.l(new Date(2008, 0, 1, 20, 20), format: "%j")).toEqual('1')

  it "should localize format: given a day_of_year format (last day) it returns the correct day", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%j")).toEqual('366')

  it "should localize format: given a 24 hour format it returns the correct hour not padded", ->
    expect(@instance.l(new Date(2008, 11, 31, 6, 20), format: "%k")).toEqual('6')

  it "should localize format: given a 24 hour format it returns the correct hour not padded", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%k")).toEqual('20')

  it "should localize format: given a 12 hour format it returns the correct hour not padded", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%l")).toEqual('8')

  it "should localize format: given a 12 hour format it returns the correct hour not padded", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%l")).toEqual('8')

  it "should localize format: given a week day format it returns the correct week day", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%w")).toEqual('3')

  it "should localize format: given a abbr year format it returns the correct year", ->
    expect(@instance.l(new Date(2008, 11, 31, 20, 20), format: "%y")).toEqual('08')
