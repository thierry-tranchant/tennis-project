class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.references :scrapp, null: false, foreign_key: true
      t.references :tennisplayer, null: false, foreign_key: true
      t.integer :seed
      t.boolean :qualified
      t.boolean :wildcard

      t.timestamps
    end
  end
end
