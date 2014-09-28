require "idioma/engine"

module Idioma

  class Configuration
    attr_accessor :default_locale, :locales, :ignore_keys

    def initialize
      self.default_locale = :en
      self.locales = [self.default_locale]
      self.ignore_keys = ["ransack", "simple_form"]
    end
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

end