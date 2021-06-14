class AddScrappToGames < ActiveRecord::Migration[6.0]
  def change
    add_reference :games, :scrapp, null: false, foreign_key: true
  end
end
