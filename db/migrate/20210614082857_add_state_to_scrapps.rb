class AddStateToScrapps < ActiveRecord::Migration[6.0]
  def change
    add_column :scrapps, :state, :string
  end
end
