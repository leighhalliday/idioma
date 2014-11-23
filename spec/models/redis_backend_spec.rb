require 'spec_helper'

describe Idioma::RedisBackend do

  describe "#integer?" do
    it "should determine correctly" do
      expect(Idioma::RedisBackend.integer?("5")).to eq(true)
      expect(Idioma::RedisBackend.integer?("-5")).to eq(true)
      expect(Idioma::RedisBackend.integer?("No")).to eq(false)
      expect(Idioma::RedisBackend.integer?("5.5")).to eq(false)
      expect(Idioma::RedisBackend.integer?("5a")).to eq(false)
    end
  end

  describe "#float?" do
    it "should determine correctly" do
      expect(Idioma::RedisBackend.float?("5")).to eq(true)
      expect(Idioma::RedisBackend.float?("-5")).to eq(true)
      expect(Idioma::RedisBackend.float?("No")).to eq(false)
      expect(Idioma::RedisBackend.float?("5.5")).to eq(true)
      expect(Idioma::RedisBackend.float?("5.5a")).to eq(false)
    end
  end

  describe "#parse_value" do
    it "parses array" do
      expect(Idioma::RedisBackend.parse_value("[1,2]").class).to eq(Array)
    end
    it "parses hash" do
      expect(Idioma::RedisBackend.parse_value("{hey: :there}").class).to eq(Hash)
    end
    it "parses nil" do
      expect(Idioma::RedisBackend.parse_value("nil").class).to eq(NilClass)
    end
    it "parses integer" do
      expect(Idioma::RedisBackend.parse_value("5").class).to eq(Fixnum)
    end
    it "parses float" do
      expect(Idioma::RedisBackend.parse_value("5.5").class).to eq(Float)
    end
    it "parses string" do
      expect(Idioma::RedisBackend.parse_value("string").class).to eq(String)
      expect(Idioma::RedisBackend.parse_value("[nil}").class).to eq(String)
    end
  end

end