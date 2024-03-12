# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    # users routes
    resources :users, only: [] do
      collection do
        post '/', action: :create # ユーザー登録
        post '/login', action: :login # ユーザーログイン
        get '/', action: :show # ユーザー情報取得
        put '/', action: :update # ユーザー情報更新
        delete '/', action: :destroy # ユーザー情報削除
      end
    end
    # trips routes
    # resources :trips, only: %i[index show create update destroy] do
    # end
  end
end
