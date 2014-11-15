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

### Configuration
Setting | Default | Description
------- | ------- | -----------
default_locale | :en | Used for showing the default translation (for translators to translate from) for a given phrase
locales | [:en] | Idioma will only import translations of locales in this list... ignoring the rest
ignore_keys | ["ransack", "simple_form"] | Gems sometimes bring their own phrases that you don't actually need translated
redis_backend | nil | Should be an I18n backend of a Redis store.

### Setup
Import the migrations into your application
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

### Example
```ruby
$redis = Redis.new(:host => 'localhost', :port => 6379)
I18n.backend = I18n::Backend::KeyValue.new($redis)

Idioma.configure do |configure|
  configure.default_locale = :en
  configure.locales = [:en, :es, :fr]
  configure.redis_backend = I18n.backend
end
```
