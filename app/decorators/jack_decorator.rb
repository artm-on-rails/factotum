# frozen_string_literal: true

# Jack decorator: methods added to a jack model in views
module JackDecorator
  def of_all_trades_tooltip
    "#{email} is jack of all trades" if of_all_trades?
  end

  def assignable_trades
    return [] if of_all_trades?

    Trade.accessible_by(current_ability) - trades
  end
end
