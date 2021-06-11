class CreateTennisplayersScrappsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :tennisplayers, :scrapps
  end
end
