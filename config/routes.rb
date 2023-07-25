Rails.application.routes.draw do
  devise_for :travellers
  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      resources :tours
    end
  end
end
