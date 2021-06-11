class CreateLeagues < ActiveRecord::Migration[6.0]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :encrypted_password
      t.boolean :public

      t.timestamps
    end
  end
end
