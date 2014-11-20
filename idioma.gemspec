$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "idioma/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "idioma"
  s.version     = Idioma::VERSION
  s.authors     = ["Leigh Halliday"]
  s.email       = ["leighhalliday@gmail.com"]
  s.homepage    = "https://github.com/leighhalliday/idioma"
  s.summary     = "Idioma is a gem for managing translations through an interface."
  s.description = "Idioma is a gem for managing translations through an interface. " +
    "Translations are saved in Postgres and can be persisted to Redis."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  # Dependencies
  s.add_dependency 'pg',             '>= 0.17'
  s.add_dependency 'rails',          '>= 4.0'
  s.add_dependency 'haml',           '>= 4.0'
  s.add_dependency 'bootstrap-sass', '>= 3.3'
  s.add_dependency 'jquery-rails',   '>= 3.1'
  s.add_dependency 'will_paginate',  '>= 3.0'
  s.add_dependency 'coffee-rails',   '>= 4.0'

  # Dev Dependencies
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'factory_girl_rails', '~> 4.5'
  s.add_development_dependency 'redis', '~> 3.1'
end
