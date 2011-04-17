
require 'bundler/setup'
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'
require 'rake/minify'

Rake::Minify.new do
  dir("coffeescripts") do # we specify only the source directory
    group("build/output.js") do
      add("Player.coffee") # the coffee file is compiled and minified
      add("Song.coffee") # the coffee file is compiled and minified
    end
  end
end
