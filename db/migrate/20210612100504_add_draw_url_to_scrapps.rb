class AddDrawUrlToScrapps < ActiveRecord::Migration[6.0]
  def change
    add_column :scrapps, :draw_url, :string
  end
end
