class Prono < ApplicationRecord
  belongs_to :tournament
  belongs_to :leagueplayer
  belongs_to :game
  belongs_to :winner, class_name: 'Tennisplayer'
  belongs_to :loser, class_name: 'Tennisplayer'
end
