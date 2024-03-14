# frozen_string_literal: true

class IntegrationTripRetrun < ActiveRecord::Migration[7.1]
  def change
    # trips_retrunテーブルを削除
    drop_table :trip_returns

    # tripsテーブルにカラムを追加
    add_column :trips, :return_time, :datetime
    add_column :trips, :return_details, :text
  end
end
