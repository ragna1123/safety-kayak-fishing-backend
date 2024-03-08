# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    # users routes
    resources :users, only: %i[create show update destroy] do
      post 'login', on: :collection
    end
  end
end
