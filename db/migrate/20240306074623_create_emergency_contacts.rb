class CreateEmergencyContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :emergency_contacts do |t|
      t.integer :user_id
      t.string :name
      t.string :relationship
      t.string :phone_number
      t.string :email
      t.string :line_id

      t.timestamps
    end
  end
end
