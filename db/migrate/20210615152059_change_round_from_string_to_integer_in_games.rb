class ChangeRoundFromStringToIntegerInGames < ActiveRecord::Migration[6.0]
  def change
    change_column :games, :round, :integer, using: 'round::integer'
  end
end
