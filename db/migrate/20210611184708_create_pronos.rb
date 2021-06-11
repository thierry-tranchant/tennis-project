class CreatePronos < ActiveRecord::Migration[6.0]
  def change
    create_table :pronos do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :leagueplayer, null: false, foreign_key: true
      t.integer :winner_id
      t.integer :loser_id
      t.string :round
      t.integer :index

      t.timestamps
    end
  end
end
