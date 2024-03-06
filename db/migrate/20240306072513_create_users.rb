class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :profile_image_url, null: true, default: ""

      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email, unique: true
  end
end
