Idioma.configure do |configure|

  configure.default_locale = :en
  configure.locales = [:en, :es, :fr]
  unless Rails.env.test?
    configure.redis_backend = I18n.backend
  end

end