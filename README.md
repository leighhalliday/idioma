# Idioma

Idioma is a Ruby Engine to help manage the flow and editing of translations.

### Current Features
* Imports translations into database from the config yaml files.
* Interface for managing translations.
* Duplicate translations from one locale to other locales.

### Pending Features
* Export translations from DB into CSV or yaml format.
* Import translations from CSV into DB.
* Sync DB changes into Redis (website runs off of Redis translations, but are managed through ActiveRecord).
* Stats on each locale, giving percentage of translated/missing.
* Inline translation editing

### Configuration
Setting | Default | Description
------- | ------- | -----------
default_locale | :en | Used for showing the default translation (for translators to translate from) for a given phrase
locales | [:en] | Idioma will only import translations of locales in this list... ignoring the rest
ignore_keys | ["ransack", "simple_form"] | Gems sometimes bring their own phrases that you don't actually need translated
