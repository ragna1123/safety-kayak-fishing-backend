# frozen_string_literal: true

class FavoriteLocationsController < ApplicationController
  before_action :jwt_authenticate

  # お気に入り地点の登録
  def create
    # location_dataから緯度と経度を抽出
    location_data = favorite_location_params[:location_data]
    latitude = location_data[:latitude]
    longitude = location_data[:longitude]

    # Location オブジェクトを検索または作成
    location = Location.find_or_create_by(latitude:, longitude:)

    # FavoriteLocation オブジェクトを構築
    favorite_location = @current_user.favorite_locations.build(favorite_location_params.except(:location_data))
    favorite_location.location = location

    if favorite_location.save
      render json: { status: 'success', message: 'お気に入りの出船地点が登録されました', data: favorite_location }, status: :created
    else
      render_error('リクエストの値が無効です')
    end
  end

  # お気に入り地点の一覧取得
  def index
    favorite_locations = @current_user.favorite_locations.includes(:location)
    if favorite_locations.present?
      data = favorite_locations.map do |favorite_location|
        {
          id: favorite_location.id,
          location_name: favorite_location.location_name,
          description: favorite_location.description,
          location_data: {
            latitude: favorite_location.location.latitude,
            longitude: favorite_location.location.longitude
          }
        }
      end
      render json: { status: 'success', data: }, status: :ok
    else
      render json: { status: 'success', message: 'お気に入りの出船地点はありません' }, status: :ok
    end
  end

  # お気に入り地点の削除
  def destroy
    favorite_location = @current_user.favorite_locations.find_by(id: params[:id])
    if favorite_location.nil?
      render json: { status: 'error', message: 'お気に入りの出船地点が見つかりません' }, status: :not_found
      return
    end

    if favorite_location.destroy
      render json: { status: 'success', message: 'お気に入りの出船地点が削除されました' }, status: :ok
    else
      render_error('お気に入りの出船地点の削除に失敗しました')
    end
  end

  private

  def favorite_location_params
    params.require(:favorite_location).permit(:location_name, :description, location_data: %i[latitude longitude])
  end

  def render_error(message)
    render json: { status: 'error', message: }, status: :unprocessable_entity
  end
end
