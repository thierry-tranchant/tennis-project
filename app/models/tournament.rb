class Tournament < ApplicationRecord
  has_and_belongs_to_many :tennisplayers
  belongs_to :league
  belongs_to :scrapp
  has_many :games
end
