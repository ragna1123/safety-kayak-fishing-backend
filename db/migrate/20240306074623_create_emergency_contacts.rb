# frozen_string_literal: true

class CreateEmergencyContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :emergency_contacts do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :relationship, null: false
      t.string :phone_number, null: true
      t.string :email, null: false
      t.string :line_id, null: true

      t.timestamps
    end
    add_index :emergency_contacts, :user_id
    add_index :emergency_contacts, :email, unique: true
    add_foreign_key :emergency_contacts, :users, column: :user_id, on_delete: :cascade
  end
end
