class ChangeScoreIntoStringInGames < ActiveRecord::Migration[6.0]
  def change
    change_column :games, :score, :string, using: 'score::varchar'
  end
end
