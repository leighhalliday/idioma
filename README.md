# Idioma

Idioma is a Ruby Engine to help manage the flow and editing of translations.

### Current Features
* Imports translations into database from the config yaml files.
* Interface for managing translations.
* Duplicate translations from one locale to other locales.
* DB changes will be persisted to Redis I18n backend store if supplied.

### Pending Features
* Export translations from DB into CSV or yaml format.
* Import translations from CSV into DB.
* Stats on each locale, giving percentage of translated/missing.
* Inline translation editing
* Test persisting to Redis using https://github.com/guilleiguaran/fakeredis

### Configuration
Setting | Default | Description
------- | ------- | -----------
default_locale | :en | Used for showing the default translation (for translators to translate from) for a given phrase
locales | [:en] | Idioma will only import translations of locales in this list... ignoring the rest
ignore_keys | ["ransack", "simple_form"] | Gems sometimes bring their own phrases that you don't actually need translated
redis_backend | nil | Should be an I18n backend of a Redis store.

### Example
```
$redis = Redis.new(:host => 'localhost', :port => 6379)
I18n.backend = I18n::Backend::KeyValue.new($redis)

Idioma.configure do |configure|
  configure.default_locale = :en
  configure.locales = [:en, :es, :fr]
  configure.redis_backend = I18n.backend
end
```
