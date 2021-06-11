class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.references :tournament, null: false, foreign_key: true
      t.integer :first_player_id
      t.integer :second_player_id
      t.integer :winner_id
      t.integer :loser_id
      t.boolean :played
      t.integer :score
      t.string :round
      t.integer :index

      t.timestamps
    end
  end
end
