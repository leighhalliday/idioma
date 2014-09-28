module Idioma
  class PhraseExporter

    def self.to_csv(scope, file_path)
      CSV.open(file_path, 'w') do |csv_object|
        csv_object << [
          "Locale",
          "Key",
          "Value"
        ]
        scope.find_each do |phrase|
          csv_object << [
            phrase.locale,
            phrase.i18n_key,
            phrase.i18n_value
          ]
        end
      end
    end

    # not yet implemented
    def self.to_yaml(scope)
      phrases = scope.order(:locale, :i18n_key).pluck(:locale, :i18n_key, :i18n_value)
      raise new Exception("Not yet implemented")
      # need to convert into hash
      # hash.to_yaml written to file
    end

    # to convert from "dotted.hash.something" to a hash [:dotted][:hash][:something]
    def self.undot_it(hash)
      new_hash = {}
      hash.each do |key, val|
        new_key, new_sub_key = key.to_s.split('.')
        new_key = new_key.to_sym
        unless new_sub_key.nil?
          new_sub_key = new_sub_key.to_sym
          new_hash[new_key] = {} if new_hash[new_key].nil?
          new_hash[new_key].merge!({new_sub_key => val})
        else
          new_hash.store(key, val)
        end
      end
    end

  end
end