require 'spec_helper'

describe Idioma::PhraseExtractor do

  let(:mocked_translations) {
    {
      en: {
        validations: {presence: "must be present"}
      }
    }
  }

  describe "get_translations" do
    it "returns the translations in the locales files" do
      expect(Idioma::PhraseExtractor.get_translations.keys).to include(:en)
    end

    it "can accept custom backends" do
      backend = I18n::Backend::Simple.new
      allow(backend).to receive(:init_translations)
      allow(backend).to receive(:translations).and_return(mocked_translations)
      expect(Idioma::PhraseExtractor.get_translations(backend)).to eq(mocked_translations)
    end
  end

  describe "to_dotted_hash" do

    it "converts when empty" do
      expect(Idioma::PhraseExtractor.to_dotted_hash({})).to eq({})
    end

    it "converts when one level" do
      expect(Idioma::PhraseExtractor.to_dotted_hash({name: "Name"})).
        to eq({"name" => "Name"})
    end

    it "converts when many levels" do
      expect(Idioma::PhraseExtractor.to_dotted_hash({validations: {presence: "must be present"}})).
        to eq({"validations.presence" => "must be present"})
    end

  end

  describe "extract" do
    it "returns dotted hashes of each locale" do
      allow(Idioma::PhraseExtractor).to receive(:get_translations).and_return(mocked_translations)

      extraction = Idioma::PhraseExtractor.extract
      expect(extraction).to eq({:en=>{"validations.presence"=>"must be present"}})
    end
  end

end