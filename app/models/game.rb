class Game < ApplicationRecord
  belongs_to :scrapp
  has_many :pronos
  belongs_to :first_player, class_name: 'Tennisplayer'
  belongs_to :second_player, class_name: 'Tennisplayer'
  belongs_to :winner, class_name: 'Tennisplayer'
  belongs_to :loser, class_name: 'Tennisplayer'

  def initialize_games

  end
end
