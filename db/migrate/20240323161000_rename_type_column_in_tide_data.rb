class RenameTypeColumnInTideData < ActiveRecord::Migration[7.1]
  def change
    rename_column :tide_data, :type, :tide_type
  end
end
