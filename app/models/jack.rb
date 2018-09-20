class Jack < ApplicationRecord
  devise :database_authenticatable
  has_many :occupations
  has_many :trades, through: :occupations
end
