class RemoveAgainLeagueplayerFromPronos < ActiveRecord::Migration[6.0]
  def change
    def change
      remove_reference :pronos, :leagueplayer, index: true, foreign_key: true
    end
  end
end
