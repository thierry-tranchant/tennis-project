class AddTournamentYearToScrapps < ActiveRecord::Migration[6.0]
  def change
    add_column :scrapps, :tournament_year, :integer
  end
end
