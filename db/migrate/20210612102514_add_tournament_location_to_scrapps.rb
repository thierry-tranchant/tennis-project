class AddTournamentLocationToScrapps < ActiveRecord::Migration[6.0]
  def change
    add_column :scrapps, :tournament_location, :string
  end
end
