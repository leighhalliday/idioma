require 'pg'
require 'haml'
require 'will_paginate'
require 'bootstrap-sass'
require 'jquery-rails'
require 'coffee-rails'

module Idioma
  class Engine < ::Rails::Engine
    isolate_namespace Idioma

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
