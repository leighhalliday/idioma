module Idioma
  class RedisBackend
    def self.delete_phrase(phrase)
      Idioma.configuration.redis_backend.store.del("#{phrase.locale}.#{phrase.i18n_key}")
    end

    def self.update_phrase(phrase)
      Idioma.configuration.redis_backend.
        store_translations(phrase.locale, {phrase.i18n_key => phrase.i18n_value}, :escape => false)
    end
  end
end