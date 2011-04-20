ci-18n
======

This javascript library tries to bring the power of the 
[I18n ruby library](https://github.com/svenfuchs/i18n.git) 
to javascript.

Currently this library is on active development, so use it with caution.

Usage
------

Really, this hasn't been established yet.

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
