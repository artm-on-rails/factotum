# Occupations associate jacks and trades, as well as encapsulate the "master"
# relationship. It's an internal detail of a Jack, it shouldn't be necessary
# to use it directly much.
class Occupation < ApplicationRecord
  belongs_to :jack
  belongs_to :trade
end
