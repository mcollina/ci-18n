# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ci-18n}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matteo Collina"]
  s.date = %q{2011-06-02}
  s.description = %q{A localization library for javascript files in ruby on rails.}
  s.email = %q{hello@matteocollina.com}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".rvmrc",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "README.md",
    "Rakefile",
    "VERSION",
    "build/.gitkeep",
    "coffeescripts/I18n.coffee",
    "javascripts/sprintf-0.7-beta1.js",
    "spec/coffeescripts/autoloadSpec.coffee",
    "spec/coffeescripts/helpers/SpecHelper.coffee",
    "spec/coffeescripts/languageRepositorySpec.coffee",
    "spec/coffeescripts/localizeSpec.coffee",
    "spec/coffeescripts/translateSpec.coffee",
    "spec/coffeescripts/utilsSpec.coffee",
    "spec/javascripts/support/jasmine.yml",
    "spec/javascripts/support/jasmine_config.rb",
    "spec/javascripts/support/jasmine_runner.rb"
  ]
  s.homepage = %q{http://github.com/mcollina/ci-18n}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.3}
  s.summary = %q{A localization library for javascript files in ruby on rails.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ci-18n>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_development_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_development_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_development_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_development_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_development_dependency(%q<rake-minify>, ["~> 0.3"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_development_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_development_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_development_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_development_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_development_dependency(%q<rake-minify>, ["~> 0.3"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_development_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_development_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_development_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_development_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_development_dependency(%q<rake-minify>, ["~> 0.3"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_development_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_development_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_development_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_development_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_development_dependency(%q<rake-minify>, ["~> 0.3"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_development_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_development_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_development_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_development_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_development_dependency(%q<rake-minify>, ["~> 0.3"])
    else
      s.add_dependency(%q<ci-18n>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_dependency(%q<rake-minify>, ["~> 0.3"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_dependency(%q<rake-minify>, ["~> 0.3"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_dependency(%q<rake-minify>, ["~> 0.3"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_dependency(%q<rake-minify>, ["~> 0.3"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
      s.add_dependency(%q<jasmine>, ["~> 1.0"])
      s.add_dependency(%q<guard>, ["~> 0.3.1"])
      s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
      s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
      s.add_dependency(%q<rake-minify>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<ci-18n>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
    s.add_dependency(%q<jasmine>, ["~> 1.0"])
    s.add_dependency(%q<guard>, ["~> 0.3.1"])
    s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
    s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
    s.add_dependency(%q<rake-minify>, ["~> 0.3"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
    s.add_dependency(%q<jasmine>, ["~> 1.0"])
    s.add_dependency(%q<guard>, ["~> 0.3.1"])
    s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
    s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
    s.add_dependency(%q<rake-minify>, ["~> 0.3"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
    s.add_dependency(%q<jasmine>, ["~> 1.0"])
    s.add_dependency(%q<guard>, ["~> 0.3.1"])
    s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
    s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
    s.add_dependency(%q<rake-minify>, ["~> 0.3"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
    s.add_dependency(%q<jasmine>, ["~> 1.0"])
    s.add_dependency(%q<guard>, ["~> 0.3.1"])
    s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
    s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
    s.add_dependency(%q<rake-minify>, ["~> 0.3"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<coffee-script>, ["~> 2.2.0"])
    s.add_dependency(%q<jasmine>, ["~> 1.0"])
    s.add_dependency(%q<guard>, ["~> 0.3.1"])
    s.add_dependency(%q<guard-coffeescript>, ["~> 0.2.0"])
    s.add_dependency(%q<guard-livereload>, ["~> 0.1.9"])
    s.add_dependency(%q<rake-minify>, ["~> 0.3"])
  end
end

