ci-18n
======

This javascript library tries to bring the power of the 
[I18n ruby library](https://github.com/svenfuchs/i18n.git) 
to javascript.

Currently this library is on active development, so use it with caution.

Installation
------

This library has been though to be used inside a [Ruby on Rails][rails]
application, namely rails 3.1 and its new asset pipeline.

[rails]: http://www.rubyonrails.org

### Installation within rails 3.1

It's as simple as running in your rails root:

    echo 'gem "ci-18n"' >> Gemfile

Then you should simply include the `ci-18n` js file where you want.
Namely you could include it inside your `application.js` or externalize
it. Note that running `rake assets:precompile` will compile it.

### Installation without rails 3.1

Download the file stored [here][download_link] and put it near
your other javascripts.

[download_link]: https://github.com/mcollina/ci-18n/raw/master/build/ci-18n.min.js

General usage
--------------------

### Translation files loading

There are two possible strategies for loading the translation files:

1. include +all of them+ inside your `application.js` for faster loading, 
   and in this case you should add `I18n.autosetup("en")` to your main
   js file (if en is your default language);
2. autoload it at runtime from the browser, and in this case you have
   to:
   * publish your translation files under the `/locales` folder.
   * add `I18.autoloadAndSetup({ path: "/locales", default: "en" })` if
     en is your default language.

### Translation file syntax

    I18n.addLanguage("en", { hello: "world", another: "aaa" });

For translating date and times, it follows the very same rules of the
I18n ruby gem, and you might want to use the same data once ported to
javascript, like so:

    I18n.addLanguage("de", { 
        date: {
          formats: {
            "default": "%d.%m.%Y",
            short: "%d. %b",
            long: "%d. %B %Y"
          },
          day_names: ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"],
          abbr_day_names: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
          month_names: ["Januar", "Februar", "März", "April", "Mai", 
                        "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember", null],
          abbr_month_names: ["Jan", "Feb", "Mar", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]
        },
        time: {
          formats: {
            "default": "%a, %d. %b %Y %H:%M:%S %z",
            short: "%d. %b %H:%M",
            long: "%d. %B %Y %H:%M"
          },
          am: 'am',
          pm: 'pm'
        }
    });

### Translation & Localization

Really, if you are familiar with the ruby [I18n][i18n] library, it just works
the same. 

You can translate with:

    $i18n.t("hello.world")

If you want to localize a datetime:

    $i18n.l(new Date(), format: "default", type: "datetime")

or if you want to localize just a date:

    $i18n.l(new Date(), format: "default", type: "date")

[i18n]: https://github.com/svenfuchs/i18n

TODO
----

* Testing on all major browser.
* Add some documentation.
* More documentation.
* Examples.
* Build a website.
* Build a translation repository like the one for I18n.
* Use of the rails asset pipeline to build a langs.js with all language
  translations.
* Simplify autoloading.
* Clean up the development environment.

Development Environment
------

Currently the build uses heavily some ruby gems, so run:

    bundle install

This library is built with [CoffeeScript](https://github.com/jashkenas/coffee-script),
so you need to install it before doing everything else.

As it's built with CoffeeScript, we need to rebuild the sources before each test run,
and for that purpose start [Guard](https://github.com/guard/guard) with
the command:

    guard

To build everything, hit 

    CTRL-\

To run the specs in the browser, launch the command

    rake jasmine

and head to http://localhost:8888.

Finally, to build the js version to use in your code, run:

    rake minify

That generates two files under the build/ directory, ci-18n.js and ci-18n.min.js.

Development
-----

* Source hosted at GitHub.
* Report Issues/Questions/Feature requests on GitHub Issues.

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change you make. 
