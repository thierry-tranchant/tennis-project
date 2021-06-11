class CreateScrapps < ActiveRecord::Migration[6.0]
  def change
    create_table :scrapps do |t|
      t.string :tournament_name
      t.integer :tournament_number
      t.boolean :drawed
      t.date :start_date
      t.date :end_date
      t.integer :index

      t.timestamps
    end
  end
end
