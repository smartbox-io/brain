Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: %i(create destroy) do
        collection do
          match "/", to: "sessions#update", via: [:put, :patch]
        end
      end
      resources :objects, only: %i(show create destroy)
    end
  end
end
