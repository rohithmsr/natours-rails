Rails.application.routes.draw do
  root 'tours#index'

  resources :tours
end
