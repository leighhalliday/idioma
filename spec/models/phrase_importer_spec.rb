require 'spec_helper'

describe Idioma::PhraseImporter do

  let(:mocked_translations) {
    {
      en: {
        validations: {presence: "must be present"}
      }
    }
  }

  describe "import_from_extraction" do
    it "imports the extracted translations" do
      allow(Idioma::PhraseExtractor).to receive(:extract).and_return(mocked_translations)
      expect {
        Idioma::PhraseImporter.import_from_extraction
      }.to change{Idioma::Phrase.count}.by(1)
    end
  end

  describe "import" do
    it "imports a locales phrases" do
      expect{
        Idioma::PhraseImporter.import(:en, mocked_translations[:en])
      }.to change{Idioma::Phrase.count}.by(1)
    end
  end

end