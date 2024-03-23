class AddLineId < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :line_id, :string
  end
end
