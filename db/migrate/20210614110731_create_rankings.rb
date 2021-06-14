class CreateRankings < ActiveRecord::Migration[6.0]
  def change
    create_table :rankings do |t|
      t.date :date
      t.integer :value
      t.references :tennisplayer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
