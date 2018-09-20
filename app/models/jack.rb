class Jack < ApplicationRecord
  devise :database_authenticatable
  has_many :occupations
  has_many :mastered_occupations,
           -> { where master: true },
           class_name: "Occupation"
  has_many :trades, through: :occupations
  has_many :mastered_trades,
           through: :mastered_occupations,
           source: :trade

  def of_all_trades?
    email[/factotum/].present?
  end

  def is_master_of? trade
    of_all_trades? || mastered_trades.exists?(trade.id)
  end
end
