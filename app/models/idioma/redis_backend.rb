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
      Idioma.configuration.redis_backend.
        store_translations(phrase.locale, {phrase.i18n_key => phrase.i18n_value}, :escape => false)
    end
  end
end