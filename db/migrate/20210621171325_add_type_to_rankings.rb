class AddTypeToRankings < ActiveRecord::Migration[6.0]
  def change
    add_column :rankings, :type, :string
  end
end
