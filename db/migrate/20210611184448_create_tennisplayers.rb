class CreateTennisplayers < ActiveRecord::Migration[6.0]
  def change
    create_table :tennisplayers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :handed
      t.integer :height
      t.integer :weight
      t.string :nationality
      t.integer :atp_rank
      t.integer :race_rank

      t.timestamps
    end
  end
end
