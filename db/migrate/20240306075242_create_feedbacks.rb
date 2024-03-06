class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.text :title
      t.text :comment
      t.integer :user_id

      t.timestamps
    end
  end
end
