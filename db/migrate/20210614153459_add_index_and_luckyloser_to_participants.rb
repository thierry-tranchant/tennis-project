class AddIndexAndLuckyloserToParticipants < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :index, :integer
    add_column :participants, :luckyloser, :boolean
  end
end
