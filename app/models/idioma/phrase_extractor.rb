module Idioma
  class PhraseExtractor

    # Find all of the translations that are in the locale yaml files
    #   and convert them into a hash of dotted hash notation key/values
    #   for each locale that is found
    # @return [Hash] Dotted hash notation key/value pairs
    def self.extract
      phrase_hashes = self.get_translations

      phrase_dotted_hashes = {}
      # convert each locales translations to dotted hash
      phrase_hashes.each do |locale, phrase_hash|
        phrase_dotted_hashes[locale] = self.to_dotted_hash(phrase_hash)
      end

      phrase_dotted_hashes
    end

    # Get translations from the i18n backend
    # @param [I18n::Backend, nil] A custom I18n backend
    # @return [Hash] of translations separated by locale
    def self.get_translations(backend = nil)
      backend = I18n::Backend::Simple.new if backend.nil?
      backend.send(:init_translations)
      backend.send(:translations)
    end

    # Convert a nested Hash ({date: {format: {long: "YYYY-MM-DD"}}})
    #   to a dotted hash {"date.format.long" => "YYYY-MM-DD"}
    # @param [Hash] Nested hash input
    # @param [Hash, {}] An accumulator to store the result
    # @param [String, nil] An accumulator for the key that gets built up
    # @return [Hash] The end result after the conversion
    def self.to_dotted_hash(source, accumulator = {}, namespace = nil)
      prefix = "#{namespace}." if namespace
      case source
      when Hash
        source.each do |key, value|
          to_dotted_hash(value, accumulator, "#{prefix}#{key}")
        end
      else
        accumulator[namespace] = source
      end
      accumulator
    end

  end
end