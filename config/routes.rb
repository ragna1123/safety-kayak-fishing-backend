# frozen_string_literal: true

Rails.application.routes.draw do
  # redis setup
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  scope :api do
    # ユーザー関連のルーティング
    resource :users, only: %i[create show update destroy] do
      collection do
        post 'login', action: :login # ユーザーログイン
        delete 'logout', action: :logout # ユーザーログアウト
        get 'is_login', action: :is_login # ユーザーログイン状態確認
      end
    end

    # トリップ関連のルーティング
    resources :trips, only: %i[create index show update destroy] do
      collection do
        get 'active', to: 'trips#active' # 出船中のトリップ一覧取得
        get 'histories', to: 'trip_histories#index' # ユーザーのトリップ履歴一覧取得
        get 'returned', to: 'trip_returns#returned' # 帰投報告済みトリップ一覧取得
        get 'unreturned', to: 'trip_returns#unreturned' # 帰投報告未済みトリップ一覧取得
      end
      member do
        resource :return, only: [:update], controller: 'trip_returns' # 帰投情報の更新
        get 'history', to: 'trip_histories#show' # 特定のトリップ履歴と天気データの取得
      end
    end

    # お気に入り関連のルーティング
    resources :favorite_locations, only: %i[create index destroy], controller: 'favorite_locations'

    # 緊急連絡先関連のルーティング
    resources :emergency_contacts, only: %i[create index update destroy], controller: 'emergency_contacts'

    # フィードバック関連のルーティング
    resources :feedbacks, only: %i[create], controller: 'feedbacks'

    # line関連のルーティング
    get '/line_auth/callback', to: 'line_auth#callback'
  end
end
