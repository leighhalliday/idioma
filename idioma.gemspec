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
  s.description = "Idioma is a gem for managing translations through an interface."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  # Dependencies
  s.add_dependency 'rails', '~> 4.2.0.beta1'
  s.add_dependency 'haml', '~> 4.0.5'
  s.add_dependency 'bootstrap-sass', '~> 3.2.0.2'
  s.add_dependency 'jquery-rails', '~> 3.1.2'
  s.add_dependency 'ransack', '~> 1.4.1'
  s.add_dependency 'will_paginate', '~> 3.0.7'
  s.add_dependency 'simple_form', '~> 3.1.0.rc2'

  # Dev Dependencies
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
