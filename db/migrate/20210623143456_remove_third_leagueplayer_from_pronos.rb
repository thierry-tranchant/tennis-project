class RemoveThirdLeagueplayerFromPronos < ActiveRecord::Migration[6.0]
  def change
    def change
      remove_column :pronos, :leagueplayer_id
    end
  end
end
