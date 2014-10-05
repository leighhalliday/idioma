require 'spec_helper'

describe Idioma::PhraseExporter do

  it "exports to csv" do
    create(:phrase)
    expect(Idioma::PhraseExporter.to_csv(Idioma::Phrase)).to eq("Locale,Key,Value,Translated\nen,key,value,Yes\n")
  end

end