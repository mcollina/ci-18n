
require 'bundler/setup'
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'
require 'rake/minify'

Rake::Minify.new do
  dir("coffeescripts") do # we specify only the source directory
    group("build/ci-18n.min.js") do
      add("I18n.coffee")
    end

    group("build/ci-18n.js") do
      add("I18n.coffee", :minify => false)
    end
  end
end
