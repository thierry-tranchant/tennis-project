class AddUserToPronos < ActiveRecord::Migration[6.0]
  def change
    add_reference :pronos, :user, null: false, foreign_key: true
  end
end
