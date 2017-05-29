Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: :create do
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
  namespace :cluster_api, path: "cluster-api" do
    namespace :v1 do
      resources :cells, only: [], param: :uuid do
        collection do
          resource :discovery, only: :create, controller: "cells/discovery"
        end
        member do
          resource :heartbeat, only: :update, controller: "cells/heartbeat"
        end
      end
      resources :objects, only: [], param: :uuid do
        member do
          resource :converge, only: :create, controller: "objects/converge"
        end
      end
      resources :upload_tokens, path: "upload-tokens", param: :uuid, only: :show
      resources :download_tokens, path: "download-tokens", param: :uuid, only: :show
    end
  end
  namespace :admin_api, path: "admin-api" do
    namespace :v1 do
      resources :admins, only: %i(index create update)
      resources :cells, only: :index, param: :uuid do
        member do
          resource :accept, only: :update, controller: "cells/accept"
        end
      end
    end
  end
end
