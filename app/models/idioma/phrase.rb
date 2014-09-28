module Idioma
  class Phrase < ActiveRecord::Base

    # == Constants ============================================================

    # == Attributes ===========================================================

    #serialize :i18n_value, JSON

    # == Extensions ===========================================================

    #include Idioma::Concerns::Models::DateFlag

    # == Relationships ========================================================

    # == Validations ==========================================================

    validates :locale, :i18n_key, presence: true
    validates :i18n_key, uniqueness: { scope: :locale }

    # == Scopes ===============================================================

    scope :translated,   lambda { where("translated_at is not null") }
    scope :untranslated, lambda { where("translated_at is null") }
    scope :missing,      lambda { where("i18n_value is null") }

    # == Callbacks ============================================================

    before_validation :strip_values

    # == Class Methods ========================================================

    # Given a base locale, duplicate all phrases to a set of other locales
    #
    # @param [Symbol] The base locale
    # @param [Array] An array of other locales
    def self.duplicate_for_locales(base_locale, locales)
      locales = [locales] unless locales.class == Array
      where(locale: base_locale).find_each do |base_phrase|
        locales.each do |locale|
          unless where(locale: locale, i18n_key: base_phrase.i18n_key).exists?
            phrase = Phrase.create!({
              locale: locale,
              i18n_key: base_phrase.i18n_key
            })
          end
        end
      end
    end

    def self.prime_backend
      find_each do |phrase|
        phrase.update_backend
      end
    end

    # == Instance Methods =====================================================

    def update_and_update_backend(params = {})
      self.translated_at = Time.zone.now if self.untranslated?

      if self.update(params)
        self.update_backend
        true
      else
        false
      end
    end

    def save_and_update_backend(params = {})
      if self.save(params)
        self.update_backend
        true
      else
        false
      end
    end

    def update_backend
      if Idioma.configuration.redis_backend
        if i18n_value.present?
          Idioma::RedisBackend.update_phrase(self)
        else
          Idioma::RedisBackend.delete_phrase(self)
        end
      end
    end

    # Is this phrase translated?
    # @returns [Boolean]
    def translated?
      translated_at.present?
    end

    # Is this phrase untranslated?
    # @returns [Boolean]
    def untranslated?
      !translated?
    end

    private

    def strip_values
      [:i18n_value].each do |field|
        self.send("#{field}=", self.send(field).to_s.strip)
      end
    end

  end
end
