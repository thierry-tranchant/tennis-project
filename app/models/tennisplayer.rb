class Tennisplayer < ApplicationRecord
  has_and_belongs_to_many :scrapps
  has_and_belongs_to_many :tournaments
  has_many :wins, class_name: 'Game', foreign_key: 'winner_id'
  has_many :loses, class_name: 'Game', foreign_key: 'loser_id'
  has_many :games_as_first_player, class_name: 'Game', foreign_key: 'first_player_id'
  has_many :games_as_second_player, class_name: 'Game', foreign_key: 'second_player_id'
end
