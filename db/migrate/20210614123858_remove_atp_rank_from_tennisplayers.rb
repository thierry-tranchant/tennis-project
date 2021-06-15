class RemoveAtpRankFromTennisplayers < ActiveRecord::Migration[6.0]
  def change
    remove_column :tennisplayers, :atp_rank, :integer
  end
end
