namespace :idioma do
  desc "Import from extraction"
  task :import_from_extraction => :environment do
    Idioma::PhraseImporter.import_from_extraction
  end

  desc "Prime backend"
  task :prime_backend => :environment do
    Idioma::Phrase.prime_backend
  end

  # rake idioma:duplicate_for_locales base_locale=en new_locale=es
  desc "Duplicate for locales"
  task :duplicate_for_locales => :environment do
    if ENV["base_locale"].nil? || ENV["new_locale"].nil?
      raise new Exception("Please provide base_locale and new_locale ENV variables")
    end
    Idioma::Phrase.duplicate_for_locales(ENV["base_locale"], ENV["new_locale"])
  end
end