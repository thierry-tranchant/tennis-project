class Prono < ApplicationRecord
  belongs_to :game
  belongs_to :user
  belongs_to :winner, class_name: 'Tennisplayer'
  belongs_to :loser, class_name: 'Tennisplayer'
end
