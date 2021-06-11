class AddScrappToTournaments < ActiveRecord::Migration[6.0]
  def change
    add_reference :tournaments, :scrapp, null: false, foreign_key: true
  end
end
