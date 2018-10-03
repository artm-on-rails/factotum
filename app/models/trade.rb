# A Trade is a group of Jacks
class Trade < ApplicationRecord
  # occupations associate jacks and trades, as well as encapsulate the "master"
  # relationship. It's an internal detail of a Trade, it shouldn't be necessary
  # to use it directly much.
  has_many :occupations

  # Trade's Jacks
  has_many :jacks, through: :occupations

  # defines an attributes writer #occupation_attributes=
  # this allows passing occupation_attributes to the mass assignment methods
  accepts_nested_attributes_for \
    :occupations,
    reject_if: :all_blank,
    allow_destroy: true
end
