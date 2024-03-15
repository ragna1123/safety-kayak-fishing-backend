# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    # ユーザー関連のルーティング
    resource :users, only: %i[create show update destroy] do
      collection do
        post 'login', action: :login # ユーザーログイン
      end
    end

    # 旅行（トリップ）関連のルーティング
    resources :trips, only: %i[create index show update destroy] do
      # 特定のトリップに対する天気情報取得
      member do
        resource :weather, only: [:show], controller: 'weather'
      end

      # トリップの帰投時の処理
      resource :return, only: [:update], controller: 'trip_returns', on: :member

      # トリップの履歴に関するルーティング
      resources :histrus, only: %i[index show], controller: 'trip_histories'
    end
  end
end
