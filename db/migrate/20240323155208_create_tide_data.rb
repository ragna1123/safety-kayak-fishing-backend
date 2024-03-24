# frozen_string_literal: true

class CreateTideData < ActiveRecord::Migration[7.1]
  def change
    create_table :tide_data do |t|
      t.references :location, null: false, foreign_key: true
      t.datetime :time, null: false
      t.string :type, null: false
      t.float :height, null: false

      t.timestamps
    end
  end
end
