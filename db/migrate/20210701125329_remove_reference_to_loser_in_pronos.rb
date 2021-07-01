class RemoveReferenceToLoserInPronos < ActiveRecord::Migration[6.0]
  def change
    remove_column :pronos, :loser_id
  end
end
