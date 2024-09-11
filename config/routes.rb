# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root to: 'home#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete '/logout', to: 'auth#delete'
    # resources :bulletins, only: %i[create edit index new show update] do
    #   member do
    #     patch :archive
    #     patch :to_moderate
    #   end
    # end
    resources :repositories, only: %i[create index new show] do
      scope module: 'repositories' do
        resources :checks, only: %i[create show]
      end
    end
  end
end
