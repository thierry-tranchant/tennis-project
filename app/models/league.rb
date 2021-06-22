class League < ApplicationRecord
  has_and_belongs_to_many :users
  has_one_attached :photo
  has_many :tournaments
  has_many :leagueplayers
end
