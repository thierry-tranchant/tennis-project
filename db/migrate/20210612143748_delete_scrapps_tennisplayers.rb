class DeleteScrappsTennisplayers < ActiveRecord::Migration[6.0]
  def change
    drop_table :scrapps_tennisplayers
  end
end
