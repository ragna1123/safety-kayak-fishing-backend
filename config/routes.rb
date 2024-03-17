# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    # ユーザー関連のルーティング
    resource :users, only: %i[create show update destroy] do
      collection do
        post 'login', action: :login # ユーザーログイン
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
    resources :favorite_locations, only: %i[create destroy index], controller: 'favorite_locations'

  end
end
