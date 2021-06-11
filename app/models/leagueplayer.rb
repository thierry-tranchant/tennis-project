class Leagueplayer < ApplicationRecord
  belongs_to :league
  belongs_to :user
end
