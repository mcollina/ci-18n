
require 'bundler/setup'

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue
  puts "Unable to load jasmine gem"
  puts "  run bundle install"
end
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

task :build_vendor => :minify do
  dir = File.dirname(__FILE__) + "/vendor/assets/javascripts"
  FileUtils.mkdir_p(dir)
  FileUtils.cp("build/ci-18n.js", dir)
  FileUtils.cp("build/ci-18n.min.js", dir)
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "ci-18n"
  gem.homepage = "http://github.com/mcollina/ci-18n"
  gem.license = "MIT"
  gem.summary = %Q{A localization library for javascript files in ruby on rails.}
  gem.description = %Q{A localization library for javascript files in ruby on rails.}
  gem.email = "hello@matteocollina.com"
  gem.authors = ["Matteo Collina"]
  gem.add_development_dependency "bundler", "~> 1.0.0"
  gem.add_development_dependency 'jeweler', '>= 0'
  gem.add_development_dependency 'coffee-script', '~> 2.2.0'
  gem.add_development_dependency 'jasmine', '~> 1.0'
  gem.add_development_dependency 'guard', '~> 0.3.1'
  gem.add_development_dependency 'guard-coffeescript', '~> 0.2.0'
  gem.add_development_dependency 'guard-livereload', '~> 0.1.9'
  gem.add_development_dependency 'rake-minify', '~> 0.3'
end
Jeweler::RubygemsDotOrgTasks.new

task :build => :build_vendor
