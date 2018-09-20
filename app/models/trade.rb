class Trade < ApplicationRecord
  has_many :occupations
  has_many :jacks, through: :occupations
end
