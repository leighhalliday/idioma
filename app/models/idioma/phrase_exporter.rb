module Idioma
  class PhraseExporter

    # Produce a CSV string of Phrases based on a scope
    # @param [ActiveRecord::Relation] From the Phrase model
    # @return [String] in CSV format
    def self.to_csv(scope)
      require 'csv'
      CSV.generate do |csv_object|
        csv_object << [
          I18n.t("idioma.locale"),
          I18n.t("idioma.key"),
          I18n.t("idioma.value"),
          I18n.t("idioma.translated")
        ]
        scope.find_each do |phrase|
          csv_object << [
            phrase.locale,
            phrase.i18n_key,
            phrase.i18n_value,
            phrase.translated_at.present? ? I18n.t('idioma.ans_yes') : I18n.t('idioma.ans_no')
          ]
        end
      end
    end

    # Produce a YAML string of Phrases based on a scope
    # @param [ActiveRecord::Relation] From the Phrase model
    # @return [String] in YAML format
    def self.to_yaml(scope)
      phrases = scope.order(:locale, :i18n_key).pluck(:locale, :i18n_key, :i18n_value)

      phrase_hash = phrases.each_with_object({}) do |phrase, hsh|
        hsh["#{phrase[0]}.#{phrase[1]}"] = phrase[2]
      end

      to_nested_hash(phrase_hash).to_yaml
    end

    private

    # Will take a flat hash with dot notation (en.errors.invalid) keys and
    #   convert it to a nested hash.
    #
    # Example: {"en.hello" => "Hi"} becomes {"en" => {"hello" => "Hi"}}
    #
    # @param [Hash] Flat hash with dot notation keys
    # @return [Hash] Nested hash
    def self.to_nested_hash(input_hash)
      input_hash.each_with_object({}) do |(key, value), hsh|
        hsh.deep_merge!(dot_keys_to_hash(key.split("."), value))
      end
    end

    # Will take an array of keys and a value, and convert this into a nested
    #   hash.
    # @param [Array] Of keys
    # @param [Object] Any value
    # @return [Hash] Nested hash using the keys and value
    def self.dot_keys_to_hash(keys, value)
      if keys.length == 1
        {keys.first => value}
      else
        {keys.shift => dot_keys_to_hash(keys, value)}
      end
    end

  end
end