require "idioma/engine"

module Idioma

  class Configuration
    attr_writer :locales, :default_locale
    attr_accessor :default_locale, :ignore_keys, :redis_backend

    def initialize
      self.default_locale = :en
      self.locales = [self.default_locale]
      self.ignore_keys = ["ransack", "simple_form"]
    end

    def locales
      proc_or_value(@locales)
    end

    def default_locale
      proc_or_value(@default_locale)
    end

    private

    def proc_or_value(var)
      case
      when var.is_a?(Proc)
        var.call
      else
        var
      end
    end

  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.conf
    self.configuration
  end

  def self.configure
    yield(configuration) if block_given?
  end

end