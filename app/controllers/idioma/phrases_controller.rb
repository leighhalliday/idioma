#require_dependency "idioma/application_controller"

module Idioma
  class PhrasesController < ApplicationController
    before_action :set_phrase, only: [:edit, :update]

    # GET /phrases
    def index
      @q = Phrase.search(params[:q])
      @phrases = @q.result.paginate(:page => params[:page])
    end

    # GET /phrases/1/edit
    def edit
    end

    # PATCH/PUT /phrases/1
    def update
      if @phrase.update_and_update_backend(phrase_params)
        redirect_to [:edit, @phrase], flash: {success: t('idioma.record_updated')}
      else
        render :edit
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_phrase
        @phrase = Phrase.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:error] = t('idioma.record_not_found')
        redirect_to phrases_path
      end

      # Only allow a trusted parameter "white list" through.
      def phrase_params
        params.require(:phrase).permit(:locale, :i18n_key, :i18n_value, :flagged_at, :notes)
      end
  end
end
