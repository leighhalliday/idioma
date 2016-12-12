module Idioma
  class PhraseImporter

    # Import all of the locales and phrases from the extraction
    # The extraction comes from Idioma::PhraseExtractor.extract
    def self.import_from_extraction
      phrases = Idioma::PhraseExtractor.extract
      phrases.each do |locale, locale_phrases|
        next unless Idioma.configuration.locales.include?(locale.to_sym)
        self.import(locale, locale_phrases)
      end
    end

    # For a given locale, impot its phrases
    #
    # @param [Symbol] the locale, eg. :en
    # @param [Hash] a hash of phrases which are already in dot-notation
    def self.import(locale, locale_phrases)
      locale_phrases.each do |key, value|
        next if self.ignore_key?(key)

        phrase = Idioma::Phrase.find_by(locale: locale, i18n_key: key)
        if !phrase
          phrase = Idioma::Phrase.new({
            locale: locale,
            i18n_key: key,
            i18n_value: value,
            translated_at: Time.zone.now
          })
        elsif phrase.phrase_untranslated?
          phrase.i18n_value = value
          phrase.translated_at = Time.zone.now if value.present?
        end
        phrase.save_and_update_backend
      end
    end

    # Checks to see if a given key should be ignored based on the ignore_keys array
    #
    # @param [String] The key to check against
    # @return [Boolean] Whether to ignore this key or not
    def self.ignore_key?(key)
      Idioma.configuration.ignore_keys.each do |ignore_key|
        return true if key.to_s.include?(ignore_key)
      end
      false
    end

  end
end
