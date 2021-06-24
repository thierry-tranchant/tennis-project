class League < ApplicationRecord
  has_and_belongs_to_many :users
  has_one_attached :photo
  has_many :tournaments
  has_many :leagueplayers
  validates :name, presence: true, length: { minimum: 6 }, allow_blank: false
  validates :password, presence: true, length: { minimum: 6 }, allow_blank: false
  validates :public, presence: true
end
