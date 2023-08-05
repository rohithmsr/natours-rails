Rails.application.routes.draw do
  root "api/v1/base#home"
  devise_for :travellers, defaults: { format: :json }, path: '/api/v1/travellers',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'sign_up'
    },
    controllers: {
      sessions: 'travellers/sessions',
      registrations: 'travellers/registrations'
    }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :tours
    end
  end
end
