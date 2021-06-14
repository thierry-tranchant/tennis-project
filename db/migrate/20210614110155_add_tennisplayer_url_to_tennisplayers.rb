class AddTennisplayerUrlToTennisplayers < ActiveRecord::Migration[6.0]
  def change
    add_column :tennisplayers, :tennisplayer_url, :string
  end
end
