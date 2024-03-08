# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.text :title, null: false
      t.text :comment, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :feedbacks, :user_id
    add_foreign_key :feedbacks, :users, column: :user_id
  end
end
