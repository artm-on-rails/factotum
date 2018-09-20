# Jack represents a person in the world, jack may belong to many trades,
# some of which jack might have mastered.
class Jack < ApplicationRecord
  # minimal devise setup
  devise :database_authenticatable

  # occupations associate jacks and trades, as well as encapsulate the "master"
  # relationship. It's an internal detail of a Jack, it shouldn't be necessary
  # to use it directly much.
  has_many :occupations

  # Jack's trades
  has_many :trades, through: :occupations

  # Trade's of which Jack is a master
  has_many :mastered_trades,
           -> { where occupations: { master: true } },
           through: :occupations,
           source: :trade

  # is this a jack of all trades?
  def of_all_trades?
    email[/factotum/].present?
  end

  # the high level logic for testing if a Jack is a master of a particular
  # Trade. Unlike the prverbial "Jack of all trades, master of none", our Jack
  # of all trades is a master of every possible trade, even the trades not in
  # Jack's occupations.
  def is_master_of? trade
    of_all_trades? || mastered_trades.exists?(trade.id)
  end
end
