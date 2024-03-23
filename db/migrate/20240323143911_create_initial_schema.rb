class CreateInitialSchema < ActiveRecord::Migration[7.1]
  def change
    # emergency_contacts テーブルの作成
    create_table :emergency_contacts do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :relationship, null: false
      t.string :phone_number
      t.string :email, null: false
      t.string :line_id
      t.timestamps null: false
    end

    # favorite_locations テーブルの作成
    create_table :favorite_locations do |t|
      t.integer :user_id, null: false
      t.integer :location_id, null: false
      t.string :location_name, null: false
      t.string :description
      t.timestamps null: false
    end

    # feedbacks テーブルの作成
    create_table :feedbacks do |t|
      t.text :title, null: false
      t.text :comment, null: false
      t.integer :user_id, null: false
      t.timestamps null: false
    end

    # locations テーブルの作成
    create_table :locations do |t|
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.timestamps null: false
    end

    # trip_weathers テーブルの作成
    create_table :trip_weathers do |t|
      t.integer :trip_id, null: false
      t.integer :weather_data_id, null: false
      t.timestamps null: false
    end

    # trips テーブルの作成
    create_table :trips do |t|
      t.integer :user_id, null: false
      t.integer :location_id, null: false
      t.datetime :departure_time, null: false
      t.datetime :estimated_return_time, null: false
      t.text :details
      t.integer :safety_score
      t.datetime :sunrise_time
      t.datetime :sunset_time
      t.datetime :return_time
      t.text :return_details
      t.timestamps null: false
    end

    # users テーブルの作成
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :profile_image_url, default: ""
      t.string :line_id
      t.timestamps null: false
    end

    # weather_data テーブルの作成
    create_table :weather_data do |t|
      t.datetime :time, null: false
      t.float :temperature
      t.float :pressure
      t.integer :cloud_cover
      t.float :gust
      t.integer :humidity
      t.float :precipitation
      t.float :swell_direction
      t.float :swell_height
      t.float :swell_period
      t.float :visibility
      t.float :water_temperature
      t.float :wave_direction
      t.float :wave_height
      t.float :wave_period
      t.float :wind_wave_direction
      t.float :wind_wave_height
      t.float :wind_wave_period
      t.float :wind_direction
      t.float :wind_speed
      t.timestamps null: false
    end

    # 外部キー制約の追加
    add_foreign_key :emergency_contacts, :users, on_delete: :cascade
    add_foreign_key :favorite_locations, :locations, on_delete: :cascade
    add_foreign_key :favorite_locations, :users, on_delete: :cascade
    add_foreign_key :feedbacks, :users
    add_foreign_key :trip_weathers, :trips, on_delete: :cascade
    add_foreign_key :trip_weathers, :weather_data, column: :weather_data_id, on_delete: :cascade
    add_foreign_key :trips, :locations, on_delete: :cascade
    add_foreign_key :trips, :users, on_delete: :cascade
  end
end

