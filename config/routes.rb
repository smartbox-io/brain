Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: %i(create) do
        collection do
          match "/", to: "sessions#update", via: [:put, :patch]
          match "/", to: "sessions#destroy", via: :delete
        end
      end
      resources :objects, only: %i(show create destroy), param: :uuid do
        member do
          resource :download, only: :show, controller: "objects/downloads"
        end
      end
    end
  end
end
