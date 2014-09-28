require "spec_helper"

describe Idioma::PhrasesController do

  routes { Idioma::Engine.routes }

  describe "GET #index" do

    it "returns results" do
      phrase = create(:phrase)
      get :index
      expect(assigns(:phrases)).to include(phrase)
    end

    it "no results" do
      get :index
      expect(assigns(:phrases).empty?).to eq(true)
    end

    it "filters results" do
      phrase = create(:phrase)
      get :index, q: {i18n_key_eq: phrase.i18n_key}
      expect(assigns(:phrases)).to include(phrase)
    end

    it "filters no results" do
      phrase = create(:phrase)
      get :index, q: {i18n_key_eq: "nope"}
      expect(assigns(:phrases).empty?).to eq(true)
    end

  end

  describe "GET #edit" do
    it "when found" do
      phrase = create(:phrase)
      get :edit, id: phrase
      expect(assigns(:phrase)).to eq(phrase)
      expect(response).to be_success
    end

    it "when not found" do
      get :edit, id: 123
      expect(response).to redirect_to(phrases_path)
    end
  end

  describe "POST #update" do
    it "when not found" do
      post :update, id: 123
      expect(response).to redirect_to(phrases_path)
    end
    it "saves data" do
      phrase = create(:phrase)
      post :update, id: phrase, phrase: {i18n_value: "New value"}
      phrase.reload
      expect(assigns(:phrase)).to eq(phrase)
      expect(phrase.i18n_value).to eq("New value")
    end
    it "re-renders when validation error" do
      phrase = create(:phrase)
      post :update, id: phrase, phrase: {locale: nil}
      phrase.reload
      expect(assigns(:phrase)).to eq(phrase)
      expect(phrase.locale).to eq("en")
      expect(response).to render_template(:edit)
    end
  end

end