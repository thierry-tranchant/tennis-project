class Tennisplayer < ApplicationRecord
  has_many :participants
  has_many :scrapps, through: :participants
  has_and_belongs_to_many :tournaments
  has_many :wins, class_name: 'Game', foreign_key: 'winner_id'
  has_many :loses, class_name: 'Game', foreign_key: 'loser_id'
  has_many :games_as_first_player, class_name: 'Game', foreign_key: 'first_player_id'
  has_many :games_as_second_player, class_name: 'Game', foreign_key: 'second_player_id'


  BASE_URL = 'https://www.atptour.com/en/rankings/singles'

  def self.fetch_tennisplayers

  end
end
