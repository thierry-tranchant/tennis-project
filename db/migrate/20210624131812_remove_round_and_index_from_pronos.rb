class RemoveRoundAndIndexFromPronos < ActiveRecord::Migration[6.0]
  def change
    remove_column :pronos, :index
    remove_column :pronos, :round
  end
end
