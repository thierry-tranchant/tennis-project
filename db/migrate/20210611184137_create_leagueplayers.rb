class CreateLeagueplayers < ActiveRecord::Migration[6.0]
  def change
    create_table :leagueplayers do |t|
      t.references :league, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
