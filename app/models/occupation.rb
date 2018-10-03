# frozen_string_literal: true

# Occupations associate jacks and trades, as well as encapsulate the "master"
# relationship. It's an internal detail of a Jack, it shouldn't be necessary
# to use it directly much.
class Occupation < ApplicationRecord
  belongs_to :jack
  belongs_to :trade

  # Attributes listed as readonly will be used to create a new record but update
  # operations will ignore these fields. Once association between a Jack and a
  # Trade is estabilshed through an Occupation the association itself is a
  # constant, although its other properties (e.g. #master) may change.
  attr_readonly :jack_id, :trade_id
end
