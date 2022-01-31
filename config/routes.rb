Rails.application.routes.draw do
  resources :deputies, only: [:index, :show]

  root 'deputies#index'
end
