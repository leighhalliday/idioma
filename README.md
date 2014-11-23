# Idioma

Idioma is a Ruby Engine to help manage the flow and editing of translations.

### Current Features
* Imports translations into database from the config yaml files.
* Interface for managing translations.
* Duplicate translations from one locale to other locales.
* DB changes will be persisted to Redis I18n backend store if supplied.
* Exports translations from DB into CSV and YAML formats.

### Pending Features
* Import translations from CSV into DB.
* Stats on each locale, giving percentage of translated/missing.
* Test persisting to Redis using https://github.com/guilleiguaran/fakeredis
* Improve interface by converting into SPA with Angular.

### Starting
Add it to your gemfile.
```ruby
gem 'idioma'
```

Mount it in your config/routes.rb.
```ruby
# config/routes.rb
MyApp::Application.routes.draw do
  mount Idioma::Engine => "/idioma"
end
```

### Security
You can secure access to the Idioma interface by using [route constraints](http://guides.rubyonrails.org/routing.html#request-based-constraints).

Example 1 by IP address.
```ruby
# config/routes.rb
idioma_constraint = lambda { |request| request.remote_ip == '127.0.0.1' }
constraints idioma_constraint do
  mount Idioma::Engine => "/idioma"
end
```

Example 2 by using Devise or another warden based authentication system.
```ruby
# config/routes.rb
idioma_constraint = lambda do |request|
  current_user = request.env['warden'].user
  current_user.present? && current_user.respond_to?(:is_admin?) && current_user.is_admin?
end

constraints idioma_constraint do
  mount Idioma::Engine => "/idioma"
end
```

### Configuration
Setting | Default | Data Type | Description
------- | ------- | --------- | -----------
default_locale | :en | Symbol or lambda | Used for showing the default translation (for translators to translate from) for a given phrase
locales | [:en] | Array of symbols or lambda | Idioma will only import translations of locales in this list... ignoring the rest
ignore_keys | ["ransack", "simple_form"] | Array of strings | Gems sometimes bring their own phrases that you don't actually need translated
redis_backend | nil | I18n::Backend::KeyValue | Should be an I18n backend of a Redis store.

### Setup
Import the migrations into your application. These should be imported by default.
```
rake idioma:install:migrations
```

To populate the idioma_phrases table with translations from your locales/yaml files.
```
rake idioma:import_from_extraction
```

To duplicate all translations from a locale to a new locale (as untranslated).
```
rake idioma:duplicate_for_locales base_locale=en new_locale=es
```

### Examples
```ruby
$redis = Redis.new(:host => 'localhost', :port => 6379)
I18n.backend = I18n::Backend::KeyValue.new($redis)

Idioma.configure do |configure|
  configure.default_locale = :en
  configure.locales = [:en, :es, :fr]
  configure.redis_backend = I18n.backend
end
```

You can use procs for default_locale and locales options. If you'd like to query a database for these values.
```ruby
Idioma.configure do |configure|
  configure.default_locale = :en
  configure.locales = -> {
    [:en, :es, :fr]
  }
end
```
