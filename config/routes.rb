Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :deputies, only: [:index, :show]

  root 'deputies#index'
end
