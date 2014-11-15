require 'spec_helper'

describe Idioma::PhraseExporter do

  let(:scope) { Idioma::Phrase }

  describe "#to_csv" do
    it "converts to CSV" do
      create(:phrase)
      expect(Idioma::PhraseExporter.to_csv(scope)).to eq("Locale,Key,Value,Translated\nen,key,value,Yes\n")
    end
  end

  describe "#to_yaml" do
    it "converts to yaml" do
      create(:phrase)
      expect(Idioma::PhraseExporter.to_yaml(scope)).to eq({"en" => {"key" => "value"}}.to_yaml)
    end
  end

  describe "#to_nested_hash" do
    it "converts a flat hash with dot notation keys to nested hash" do
      input_hash = {
        "en.hello" => "Hi",
        "en.bye"   => "Bye"
      }
      expected_hash = {
        "en" => {
          "hello" => "Hi",
          "bye"   => "Bye"
        }
      }

      expect(Idioma::PhraseExporter.to_nested_hash(input_hash)).to eq(expected_hash)
    end
  end

end