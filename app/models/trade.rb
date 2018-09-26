# A Trade is a group of Jacks
class Trade < ApplicationRecord
  has_many :occupations
  has_many :jacks, through: :occupations

  accepts_nested_attributes_for \
    :occupations,
    reject_if: :all_blank,
    allow_destroy: true
end
