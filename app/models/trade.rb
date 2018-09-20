# A Trade is a group of Jacks
class Trade < ApplicationRecord
  has_many :occupations
  has_many :jacks, through: :occupations
end
