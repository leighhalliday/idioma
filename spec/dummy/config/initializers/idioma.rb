Idioma.configure do |configure|

  configure.default_locale = :en
  configure.locales = [:en, :es, :fr]
  configure.redis_backend = I18n.backend

end