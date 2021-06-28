class RemoveTournamentFromPronos < ActiveRecord::Migration[6.0]
  def change
    remove_reference :pronos, :tournament, index: true, foreign_key: true
  end
end
