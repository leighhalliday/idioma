module Idioma

  # Class for dealing with deleting and updating phrases in the i18n backend.
  #   This is specifically when the backend is Redis
  class RedisBackend

    # Delete a given Phrase from Redis
    # @param [Phrase] The Phrase to delete
    # @return [Boolean] Result of the del command in Redis
    def self.delete_phrase(phrase)
      Idioma.configuration.redis_backend.store.del("#{phrase.locale}.#{phrase.i18n_key}")
    end

    # Update (or create) a Phrase in Redis
    # @param [Phrase] The Phrase to update or create
    # @return [Boolean] Result of the store_translations command from the Redis backend (I18n::Backend)
    def self.update_phrase(phrase)
      value = self.parse_value(phrase.i18n_value)

      Idioma.configuration.redis_backend.
        store_translations(phrase.locale, {phrase.i18n_key => value}, :escape => false)
    end

    def self.integer?(input)
      !!(input =~ /^-?\d+$/)
    end

    def self.float?(input)
      true if Float(input) rescue false
    end

    def self.parse_value(value)
      case
      when (value =~ /^\[.*\]$/) || (value =~ /^\{.*\}$/)
        eval(value)
      when value == "nil"
        nil
      when self.integer?(value)
        Integer(value)
      when self.float?(value)
        Float(value)
      else
        value
      end
    end

  end
end