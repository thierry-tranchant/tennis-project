class RemoveLeagueplayerFromPronos < ActiveRecord::Migration[6.0]
  def change
    def change
      remove_reference :pronos, :leagueplayer, foreign_key: true
    end
  end
end
