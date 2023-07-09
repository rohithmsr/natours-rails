Rails.application.routes.draw do
  namespace :api do
    namespace :v1, constraints: { format: :json } do
      resources :tours
    end
  end
end
