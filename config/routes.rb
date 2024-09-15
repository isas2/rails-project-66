# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :checks, only: :create
  end

  scope module: :web do
    root to: 'home#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete '/logout', to: 'auth#delete'

    resources :repositories, only: %i[create index new show] do
      scope module: 'repositories' do
        resources :checks, only: %i[create show]
      end
    end
  end
end
