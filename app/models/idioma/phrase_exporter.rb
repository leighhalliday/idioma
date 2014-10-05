module Idioma
  class PhraseExporter

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

    # not yet implemented
    def self.to_yaml(scope)
      raise new Exception("Not yet implemented")
      phrases = scope.order(:locale, :i18n_key).pluck(:locale, :i18n_key, :i18n_value)
      # need to convert into hash
      # hash.to_yaml written to file
    end

  end
end