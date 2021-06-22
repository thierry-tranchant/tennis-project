class RenameTypeIntoCategoryInRankings < ActiveRecord::Migration[6.0]
  def change
    rename_column :rankings, :type, :category
  end
end
