require 'spec_helper'

describe Idioma::Phrase do

  describe "phrase_translated?" do

    let(:phrase) { build(:phrase) }

    it "should be translated" do
      phrase.translated_at = Time.zone.now
      expect(phrase.phrase_translated?).to eq(true)
    end

    it "should not be translated" do
      phrase.translated_at = nil
      expect(phrase.phrase_translated?).to eq(false)
    end

  end

  describe "untranslated?" do

    let(:phrase) { build(:phrase) }

    it "should be untranslated" do
      phrase.translated_at = nil
      expect(phrase.phrase_untranslated?).to eq(true)
    end

    it "should not be untranslated" do
      phrase.translated_at = Time.zone.now
      expect(phrase.phrase_untranslated?).to eq(false)
    end

  end

  describe "duplicate_for_locales" do

    before(:each) do
      create(:phrase)
    end

    it "does nothing when nothing to duplicate" do
      expect {
        Idioma::Phrase.duplicate_for_locales(:fake, [:en])
      }.to change{Idioma::Phrase.count}.by(0)
    end

    it "allows a single locale" do
      expect {
        Idioma::Phrase.duplicate_for_locales(:en, :es)
      }.to change{Idioma::Phrase.count}.by(1)
    end

    it "should duplicate for multiple locales" do
      expect {
        Idioma::Phrase.duplicate_for_locales(:en, [:es, :fr])
      }.to change{Idioma::Phrase.count}.by(2)
    end

  end

  describe "validations" do

    it "requires presence of" do
      phrase = Idioma::Phrase.new
      phrase.valid?
      expect(phrase.errors.messages).to eq({:locale=>["can't be blank"], :i18n_key=>["can't be blank"]})
    end

    it "enforces uniqueness" do
      phrase = create(:phrase)
      new_phrase = build(:phrase)
      new_phrase.valid?
      expect(new_phrase.errors.messages).to eq({:i18n_key=>["has already been taken"]})
    end

  end

end
