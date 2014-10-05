require "spec_helper"

describe Idioma::PhrasesController do

  routes { Idioma::Engine.routes }

  describe "GET #index" do

    context "html" do
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

    context "json" do
      it "returns results" do
        phrase = create(:phrase)
        get :index, format: :json
        body_hash = JSON.parse(response.body)
        expect(JSON.parse(body_hash["phrases"]).first).to eq(JSON.parse(phrase.to_json))
      end

      it "includes metadata" do
        phrase = create(:phrase)
        get :index, format: :json
        body_hash = JSON.parse(response.body)
        expect(body_hash["_metadata"]).to eq({
          "current_page"  => 1,
          "per_page"      => 30,
          "total_entries" => 1
        })
      end
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
    context "html" do
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

    context "json" do
      it "saves and renders phrase as json" do
        phrase = create(:phrase)
        post :update, id: phrase, phrase: {i18n_value: "New value"}, format: :json
        phrase.reload
        expect(response.status).to eq(200)
        expect(response.body).to eq(phrase.to_json)
      end

      it "has validation errors and returns them" do
        phrase = create(:phrase)
        post :update, id: phrase, phrase: {locale: nil}, format: :json
        expect(response.status).to eq(400)
        body_hash = JSON.parse(response.body)
        expect(body_hash["errors"]).to eq({"locale" => ["can't be blank"]})
      end
    end
  end

  describe "GET #show" do
    let (:phrase) { create(:phrase) }

    it "when not found" do
      get :show, id: 999, format: :json
      expect(response.status).to eq(404)
    end

    it "when found" do
      get :show, id: phrase, format: :json
      expect(assigns(:phrase)).to eq(phrase)
      expect(response.body).to eq(phrase.to_json)
    end
  end

end