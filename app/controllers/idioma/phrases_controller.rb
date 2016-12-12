#require_dependency "idioma/application_controller"

module Idioma
  class PhrasesController < ApplicationController
    before_action :set_phrase, only: [:edit, :update, :show]

    # GET /phrases
    def index
      params[:locale_eq] ||= I18n.default_locale
      scope = Phrase.where(locale: params[:locale_eq])

      if params[:q].present?
        scope = scope.where("i18n_key ilike ? OR i18n_value ilike ?", "%#{params[:q]}%", "%#{params[:q]}%")
      end

      respond_to do |format|
        format.html {
          @phrases = scope.paginate(:page => params[:page])
        }
        format.csv {
          render text: PhraseExporter.to_csv(scope)
        }
        format.yaml {
          render text: PhraseExporter.to_yaml(scope)
        }
        format.json {
          @phrases = scope.paginate(:page => params[:page])
          render json: {
            meta: {
              pagination: {
                current_page: @phrases.current_page,
                per_page: @phrases.per_page,
                total_entries: @phrases.total_entries
              }
            },
            phrases: @phrases
          }
        }
      end
    end

    # GET /phrases/1
    def show
      respond_to do |format|
        format.json {
          render json: @phrase
        }
      end
    end

    # PATCH/PUT /phrases/1
    def update
      result = @phrase.update_and_update_backend(phrase_params)
      respond_to do |format|
        format.html {
          if result
            redirect_to [:edit, @phrase]
          else
            render :edit
          end
        }
        format.json {
          if result
            render json: @phrase
          else
            render json: {
              errors: @phrase.errors.messages
            }.merge(@phrase.attributes),
            status: :bad_request
          end
        }
      end

    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_phrase
        @phrase = Phrase.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.json { render json: {}.to_json, status: :not_found }
          format.html {
            flash[:error] = t('idioma.record_not_found')
            redirect_to phrases_path
          }
        end
      end

      # Only allow a trusted parameter "white list" through.
      def phrase_params
        params.require(:phrase).permit(:locale, :i18n_key, :i18n_value, :flagged_at, :notes)
      end
  end
end
