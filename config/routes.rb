Idioma::Engine.routes.draw do
  root to: "phrases#index"
  resources :phrases, only: [:index, :edit, :update, :show]
end
