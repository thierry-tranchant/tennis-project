class AddGameToPronos < ActiveRecord::Migration[6.0]
  def change
    add_reference :pronos, :game, null: false, foreign_key: true
  end
end
