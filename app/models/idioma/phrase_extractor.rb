module Idioma
  class PhraseExtractor

    def self.extract
      phrase_hashes = self.get_translations

      phrase_dotted_hashes = {}
      # convert each locales translations to dotted hash
      phrase_hashes.each do |locale, phrase_hash|
        phrase_dotted_hashes[locale] = self.to_dotted_hash(phrase_hash)
      end

      phrase_dotted_hashes
    end

    def self.get_translations(backend = nil)
      backend = I18n::Backend::Simple.new if backend.nil?
      backend.send(:init_translations)
      backend.send(:translations)
    end

    def self.to_dotted_hash(source, target = {}, namespace = nil)
      prefix = "#{namespace}." if namespace
      case source
      when Hash
        source.each do |key, value|
          to_dotted_hash(value, target, "#{prefix}#{key}")
        end
      else
        target[namespace] = source
      end
      target
    end

  end
end