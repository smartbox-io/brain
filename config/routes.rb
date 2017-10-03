require "sidekiq/web"

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: :create do
        collection do
          match "/", to: "sessions#update", via: %i[put patch]
          match "/", to: "sessions#destroy", via: :delete
        end
      end
      resources :objects, only: %i[show create destroy], param: :uuid do
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
      resources :objects, only: :create, param: :uuid do
        member do
          resource :converge, only: :create, controller: "objects/converge"
        end
      end
      resources :upload_tokens, path: "upload-tokens", param: :token, only: :show
      resources :download_tokens, path: "download-tokens", param: :token, only: :show
      resources :sync_tokens, path: "sync-tokens", param: :token, only: :show
    end
  end
  namespace :admin_api, path: "admin-api" do
    namespace :v1 do
      resources :admins, only: %i[index create update]
      resources :cells, only: :index, param: :uuid do
        member do
          resource :accept, only: :update, controller: "cells/accept"
        end
      end
    end
  end
  mount Sidekiq::Web => "/sidekiq" unless Rails.env.production?
end
# rubocop:enable Metrics/BlockLength
