
require 'bundler/setup'
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'
require 'rake/minify'

Rake::Minify.new do
  group("build/ci-18n.min.js") do
    add("coffeescripts/I18n.coffee")
    add("javascripts/sprintf-0.7-beta1.js")
  end

  group("build/ci-18n.js") do
    add("coffeescripts/I18n.coffee", :minify => false)
    add("javascripts/sprintf-0.7-beta1.js", :minify => false)
  end
end
