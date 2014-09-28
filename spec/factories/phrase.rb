FactoryGirl.define do
  factory :phrase, class: Idioma::Phrase do
    locale "en"
    i18n_key "key"
    i18n_value "value"
    translated_at { Time.zone.now }
  end
end