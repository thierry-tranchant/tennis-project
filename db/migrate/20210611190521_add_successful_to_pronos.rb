class AddSuccessfulToPronos < ActiveRecord::Migration[6.0]
  def change
    add_column :pronos, :successful, :boolean
  end
end
