# frozen_string_literal: true

Caffeinate::Engine.routes.draw do
  resources :campaign_subscriptions, only: [], param: :token do
    member do
      get :unsubscribe
      get :subscribe
    end
  end
end
