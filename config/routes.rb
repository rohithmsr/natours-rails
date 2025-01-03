Rails.application.routes.draw do
  root "api/v1/base#home"
  get "api/v1", to: "api/v1/base#home"

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
      resources :tours do
        member do
          get :journeys
        end
      end
      resources :travellers, only: :show do
        patch '/deactivate', to: 'travellers#deactivate'
        patch '/reactivate', to: 'travellers#reactivate'
      end
      resources :journeys, only: %w[show create] do
        post 'assign_travellers', to: 'journeys#assign_travellers'
        delete 'unassign_travellers', to: 'journeys#unassign_travellers'
      end
      resources :orders, only: %w[show create update]
    end
  end
end
