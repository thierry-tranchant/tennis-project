class AddBirthdateToTennisplayers < ActiveRecord::Migration[6.0]
  def change
    add_column :tennisplayers, :birthdate, :date
  end
end
