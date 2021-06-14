class AddBackhandToTennisplayers < ActiveRecord::Migration[6.0]
  def change
    add_column :tennisplayers, :backhand, :string
  end
end
